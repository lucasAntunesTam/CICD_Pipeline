$Path=$args[0]
$API_PWD=$args[2]
$API_ID=$args[1]

function Get-Token {
    $body = @{client_id = $env:ORCH_CLIENT_ID
        grant_type      = 'client_credentials'
        scope           = 'OR.Execution'
        client_secret   =  $env:ORCH_SECRET
    } 
    $tokenResponse = Invoke-RestMethod -Method POST -Uri 'https://staging.uipath.com/identity_/connect/token' -Headers $header -Body $body -ContentType "application/x-www-form-urlencoded"
    return $tokenResponse.access_token
}

function Publish-Package {
    param ($Token)
        
    $header = @{
        Authorization                 = ('Bearer {0}' -f $Token)
        Accept                        = 'application/json'
        'Content-Type'                = 'multipart/form-data' 
    }

   $form         = @{name                 = 'file'
                    filename              = Get-Item -Path $Path
                    'Content-Type'        = 'application/octet-stream'
                   } 

 try {
    Invoke-RestMethod -Method POST -Uri 'https://staging.uipath.com/lucas_antunes_tam/DefaultTenant/orchestrator_/odata/Processes/UiPath.Server.Configuration.OData.UploadPackage'  -Headers $header -Form $form

 }
 catch {
    Write-Host "Package already exists"
 }
}
Publish-Package -Token ($token = Get-Token) 

