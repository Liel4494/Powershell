function AWS_Auth()
{
    Start-Process("https://d-90676863bf.awsapps.com/start#/")
    Write-Host("Enter AWS Powershell Credentials: ")
    while (1) 
    {
        read-host | Set-Variable r
        Set-Variable Auth -value ($Auth+"`n"+$r)
        if (!$r) {break}
    }
    $Auth = $Auth.trim()
    Invoke-Expression $Auth
}
function Check_input()
{
    $Y = Read-Host "Enter Y Or N"
    while (($Y.ToLower() -ne "y") -and ($Y.ToLower() -ne "n"))
    {
        $Y = Read-Host "Please Enter Only Y Or N"
    }
    return $Y
}

Write-Host("Need To Enter Credentials?")
$Y = Check_input
if ($Y.ToUpper() -eq 'Y')
{
    AWS_Auth
}
function Get_Instance_ID_And_Region($Customer_Name, $Region)
{
    $Json = aws ec2 describe-instances --filters "Name=tag:Name,Values=*$Customer_Name*" --region $Region
    $JsonData = $Json | ConvertFrom-JSON
    $Instance_ID = $JsonData.Reservations.Instances.InstanceId
    return $Instance_ID ,$Region
}
function Search_Name($Name)
{   
    
    $Customer_List = @()
    $Region = "us-east-1"
    $Customer_List += Get_CustomerName $Name $Region 
    $Region = "ap-south-1"
    $Customer_List += Get_CustomerName $Name $Region
    $Region = "eu-central-1"
    $Customer_List += Get_CustomerName $Name $Region

    $First_Latter = ($Name.Substring(0,1)).ToUpper()
    $Rest_Latters = ($Name.Substring($name.Length - ($name.Length-1),($name.Length-1))).ToLower()
    $Name = $First_Latter+$Rest_Latters
    $Region = "us-east-1"
    $Customer_List += Get_CustomerName $Name $Region 
    $Region = "ap-south-1"
    $Customer_List += Get_CustomerName $Name $Region
    $Region = "eu-central-1"
    $Customer_List += Get_CustomerName $Name $Region
    
    $Name = $Name.ToLower()
    $Region = "us-east-1"
    $Customer_List += Get_CustomerName $Name $Region 
    $Region = "ap-south-1"
    $Customer_List += Get_CustomerName $Name $Region
    $Region = "eu-central-1"
    $Customer_List += Get_CustomerName $Name $Region
    
    $Name = $Name.ToUpper()
    $Region = "us-east-1"
    $Customer_List += Get_CustomerName $Name $Region 
    $Region = "ap-south-1"
    $Customer_List += Get_CustomerName $Name $Region
    $Region = "eu-central-1"
    $Customer_List += Get_CustomerName $Name $Region

    $NoDupList = $Customer_List | Select-Object –unique

    return $NoDupList
}
function Get_CustomerName($Name, $Region)
{
    $Json = aws ec2 describe-instances --filters "Name=tag:Name,Values=*$Name*" --region $Region
    $JsonData = $Json | ConvertFrom-Json
    $Tags = $JsonData.Reservations.Instances.Tags
    $NamesList = @()
    foreach ($Tag in $Tags) 
    {
        if ($Tag.Key -eq "Customer")
        {
            if ($Tags.key -ne $NamesList[-1])
            {
                $NamesList += $Tag.Value
            }
        }
    }
    return $NamesList
}
function Server_Cache($Instance_ID, $Region, $MlpSwitch, $domain)
{   
    Write-Host("")
    $result = Send-SSMCommand -DocumentName "MLPSwitch" -Parameter @{MLPParam = "$MlpSwitch"} -Target @{Key="instanceids";Values=@("$Instance_ID")} -Region $Region
    $CommandID = $result.CommandId
    $info = Get-SSMCommandInvocation -CommandId $CommandID -Details $true -InstanceId $Instance_ID -Region $Region | Select-Object -ExpandProperty CommandPlugins | Select-Object -ExpandProperty Output
    while ([string]::IsNullOrEmpty($info))
    {
        $info = Get-SSMCommandInvocation -CommandId $CommandID -Details $true -InstanceId $Instance_ID -Region $Region | Select-Object -ExpandProperty CommandPlugins | Select-Object -ExpandProperty Output
    }
    Write-Host $info
    UpdateDynamoDBWithMLPStatus $domain $Region $MlpSwitch
    start-sleep 5

}

function UpdateDynamoDBWithMLPStatus($domain, $Region, $MlpSwitch)
{
    Write-Host("Updating DinamoDB 'saas-tenant-details' Table With MLP Status")
    $MlpSwitch = $MlpSwitch.ToLower()
    $key = '{""domainName"": {""S"": ""PLACE_HOLDER""}}'.Replace("PLACE_HOLDER", $domain)
    $expressionAttributeValues = '{"":m"": {""BOOL"": PLACE_HOLDER}}'.Replace("PLACE_HOLDER", $MlpSwitch)

    $output = aws dynamodb update-item --region "us-east-1" --table-name "saas-tenant-details" --key $key --update-expression 'SET #M = :m' --expression-attribute-names '{""#M"": ""MLP""}' --expression-attribute-values $expressionAttributeValues --return-values ALL_NEW 
    Write-Host("MLP Status Updated")
}

function Start_Session($Instance_ID, $Region)
{
    aws ssm start-session --target $Instance_ID --region $Region
} 

function Get_TenantID($Customer_Name, $Region)
{
    $Result = aws ec2 describe-instances --filters "Name=tag:Name,Values=*$Customer_Name*" --region $Region
    $JsonData = $Result | ConvertFrom-JSON
    $Tags = $JsonData.Reservations.Instances.Tags
    foreach ($Tag in $Tags)
    {
        if ($Tag.Key -eq "TenantID")
        {
            $TenantID = $Tag.Value
        }
    }
    return $TenantID
}

function Get_UserPoolID($TenantID, $Region)
{
    $Result = aws resourcegroupstaggingapi get-resources --tag-filters Key=TenantID,Values=$TenantID --region $Region
    $JsonData =$Result | ConvertFrom-JSON
    $Resource = $JsonData.ResourceTagMappingList
    $Cognito = @()
    $UserPoolID = @()
    foreach ($Res in $Resource.ResourceARN)
    {
        if ($Res -like "*cognito*")
        {
            $Cognito += $Res
        }
    }

    if ($Cognito.Length -gt 1)
    {
        foreach ($Cog in $Cognito)
        { 
            $UserPoolID += $Cog.Split('/')[1]
        }
        
        Write-Host("")
        Write-Host("Two User Pools Found:")
        $i = 1
        foreach ($Pool in $UserPoolID)
        {
            Write-Host("$i. $Pool.")
            $i = $i + 1
        }
        Write-Host("")
        $Choose = Read-Host("Enter The Line Number To Select Customer")
        $UserPoolID = $UserPoolID[$Choose -1]
        return $UserPoolID
    }
    
    $UserPoolID = $Cognito[0].Split('/')[1]
    return $UserPoolID
}

function Get_CognitoUsername($UserPoolID, $Region)
{
    $Result = aws cognito-idp list-users --user-pool-id $UserPoolID --region $Region
    $JsonData = $Result | ConvertFrom-Json
    $UsersList = $JsonData.Users | Select-Object -ExpandProperty username
    try
    {
        $UsersList = $UsersList.Split()
    }
    catch
    {
        Write-Host("")
        Write-Host("Go To AWS And Check If Cognito UserName Field is Populated.") -BackgroundColor Red -ForegroundColor Black
        Start-Sleep 3
        break
    }
    $UsersListLenght = $UsersList.Length
    if ($UsersListLenght -gt 1)
    {
        Write-Host("")
        Write-Host("$UsersListLenght Users Is Foud:")
        Write-Host("")
        $i = 1
        foreach ($user in $UsersList)
        {
            Write-Host("$i. $user")
            $i = $i + 1
        }
        Write-Host("")
        $Choose = Read-Host("Enter The Line Number To Select User")
        $UserName = $UsersList[$Choose -1]
        return $UserName
    }
    else
    {
        return $UsersList[0]
    }   
}

function SetPassword($UserPoolID, $UserName, $Region)
{
    $Password =  ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*-_/\".tochararray() | Sort-Object {Get-Random})[0..16] -join ''
    $Chars = $Password.ToCharArray()
    $Password_Policy = $false
    foreach ($char in $Chars)
    {
        if (($char -eq "!") -or ($char -eq "@") -or ($char -eq "#") -or ($char -eq "$") -or ($char -eq "%") -or ($char -eq "^") -or ($char -eq "&") -or ($char -eq "*") -or ($char -eq "-") -or ($char -eq "_") -or ($char -eq "/") -or ($char -eq "\") -or ($char -eq "1") -or ($char -eq "2") -or ($char -eq "3") -or ($char -eq "4") -or ($char -eq "5") -or ($char -eq "6") -or ($char -eq "7") -or ($char -eq "8") -or ($char -eq "9") -or ($char -eq "0"))
        {
            $Password_Policy = $true
        } 
    }
    while ($Password_Policy -eq $false)
    {
        $Password =  ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*-_/\".tochararray() | Sort-Object {Get-Random})[0..16] -join ''
        $Chars = $Password.ToCharArray()
        $Password_Policy = $false
        foreach ($char in $Chars)
        {
            if (($char -eq "!") -or ($char -eq "@") -or ($char -eq "#") -or ($char -eq "$") -or ($char -eq "%") -or ($char -eq "^") -or ($char -eq "&") -or ($char -eq "*") -or ($char -eq "-") -or ($char -eq "_") -or ($char -eq "/") -or ($char -eq "\") -or ($char -eq "1") -or ($char -eq "2") -or ($char -eq "3") -or ($char -eq "4") -or ($char -eq "5") -or ($char -eq "6") -or ($char -eq "7") -or ($char -eq "8") -or ($char -eq "9") -or ($char -eq "0"))
            {
                $Password_Policy = $true
            } 
        }
    }
    aws cognito-idp admin-set-user-password --user-pool-id $UserPoolID --username $UserName --password "$Password" --region $Region
    Write-Host("")
    Write-Host("UserName: $UserName ")
    Write-Host("Password: $Password ")
}


#########
# Start # 
#########
$Close = $false
while ($Close -ne $true)
{
    $CustomerFound = $false
    while ($CustomerFound -eq $false) {
        Write-Host("")
        $Name = Read-Host("Enter customer name")
        $Customer_List = Search_Name $Name
        if ([string]::IsNullOrEmpty($Customer_List))
        {
            Write-Host("Customer Name Not Found.") -BackgroundColor Red -ForegroundColor Black
            Start-Sleep 3
        }
        else 
        {
            $CustomerFound = $true
        }
    }
    $Choose = 1
    while ($Choose -ne 0)
    {
        $i = 1
        foreach ($Name in $Customer_List)
        {
            Write-Host("$i. $Name.")
            $i = $i + 1
        }
        Write-Host("")
        Write-Host("0.Go Back - Enter New Customer Name.")
        Write-Host("")
        Write-Host("")
        $Choose = Read-Host("Enter The Line Number To Select Customer")
        if ($Choose -eq 0)
        {
            break
        }
        $Customer_List = $Customer_List.Split()
        $Customer_Name = $Customer_List[$Choose -1]

        $Region = "us-east-1"
        $Array = Get_Instance_ID_And_Region $Customer_Name $Region
        $Instance_ID = $Array[0]
        $Region = $Array[1]
        if ($Instance_ID -eq $null)
        {
            $Region = "ap-south-1"
            $Array = Get_Instance_ID_And_Region $Customer_Name $Region
            $Instance_ID = $Array[0]
            $Region = $Array[1]
        }

        if ($Instance_ID -eq $null)
        {
            $Region = "eu-central-1"
            $Array = Get_Instance_ID_And_Region $Customer_Name $Region
            $Instance_ID = $Array[0]
            $Region = $Array[1]
        }

        if ($Instance_ID -ne $null)
        {
            Write-Host("")
            Write-Host("Customer $Customer_Name Selected.") -BackgroundColor Cyan -ForegroundColor Black
            Write-Host("") 
            Write-Host("Found in", $Region) -BackgroundColor Green -ForegroundColor Black
            Write-Host("") 
        }    

        else
        {
            Write-Host("")
            Write-Host("Customer EC2 instance ID Note Found.") -BackgroundColor Red -ForegroundColor Black
            Start-Sleep 2
            break
        }

    Write-Host("")
    @"
Choose Action:
1.Enable Server Cache.
2.Disable Server Cache.
3.Start Powershell Session.
4.Set New Password. 
"@
        Write-Host("")
        Write-Host("0.Go Back - Select Other Customer From The List.")
        Write-Host("")
        Write-Host("")
        $X = Read-host("Enter The Line Number")
        Write-Host("")
        Write-Host("")
        while ($X -ne 0){
            if ($X -eq 1)
            {
                Write-Host("")
                Write-Host("Enabling Server Cache.")
                $MlpSwitch = "True"
                $TenantID = Get_TenantID $Customer_Name $Region
                $UserPoolID = Get_UserPoolID $TenantID $Region
                $UserName = Get_CognitoUsername $UserPoolID $Region
                $domain = $UserName.Split("@")[1]
                Server_Cache $Instance_ID $Region $MlpSwitch $domain
            }
            if ($X -eq 2)
            {
                Write-Host("")
                Write-Host("Disabling Server Cache..")
                $MlpSwitch = "False"
                $TenantID = Get_TenantID $Customer_Name $Region
                $UserPoolID = Get_UserPoolID $TenantID $Region
                $UserName = Get_CognitoUsername $UserPoolID $Region
                $domain = $UserName.Split("@")[1]
                Server_Cache $Instance_ID $Region $MlpSwitch $domain
            }
            if ($x -eq 3) 
            {
                Start_Session $Instance_ID $Region    
            }
            if ($x -eq 4) 
            {
                $TenantID = Get_TenantID $Customer_Name $Region
                $UserPoolID = Get_UserPoolID $TenantID $Region
                $UserName = Get_CognitoUsername $UserPoolID $Region
                SetPassword $UserPoolID $UserName $Region
            }
            
            Write-Host("")
            Write-Host("Do You Want To Enter Another Customer?")
            $Y = Check_input
            if ($Y.ToLower() -eq "n")
            {
                Write-Host "See You Later..."
                Start-Sleep -Seconds 1
                Exit
            }
            if ($Y.ToLower() -eq "y")
            {   
                $X = 0 
                $Choose = 0
            }
        }  
    }
}