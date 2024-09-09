 function Get-Token {
  $body = @{client_id = $env:ORCH_CLIENT_ID
    grant_type      = 'client_credentials'
    scope           = 'OR.TestSets OR.Execution'
    client_secret   =  $env:ORCH_SECRET
} 
    $tokenResponse = Invoke-RestMethod -Method POST -Uri 'https://staging.uipath.com/identity_/connect/token' -Headers $header -Body $body -ContentType "application/x-www-form-urlencoded"
    return $tokenResponse.access_token
  }

function Get-ProcessInfo {
    param ($Token)   
            
    $header = @{
        Authorization                 = ('Bearer {0}' -f $Token)
        Accept                        = 'application/json'
    }
    $process = Invoke-RestMethod -Method GET -Uri "https://staging.uipath.com/lucas_antunes_tam/DefaultTenant/orchestrator_/odata/Processes?%24orderby=Published%20desc&%24top=1" -Headers $header -ContentType "application/json"
    return $process
}
 
function Add-Process {
    param ($Token, $ProcessData, $FolderId)   
            
      $header = @{
        Authorization                 = ('Bearer {0}' -f $Token)
        Accept                        = 'application/json'
        "X-UIPATH-OrganizationUnitId"   = $FolderId
    }
    
    $body = "{`"ProcessKey`": `"$($ProcessData.value.Title)`", `"ProcessVersion`": `"$($ProcessData.value.Version)`", `"Name`": `"$($ProcessData.value.Title)`", `"FeedId`": `"65c131da-6393-460c-af06-c70649b658ed`"}"
   
try {
    Invoke-RestMethod -Method POST -Uri "https://staging.uipath.com/lucas_antunes_tam/DefaultTenant/orchestrator_/odata/Releases" -Headers $header -body $body -ContentType "application/json"
}
   catch {
        Write-Host "Process exists"
    } 
}

$ProcessData = Get-ProcessInfo -Token ($token = Get-Token)
Add-Process -Token ($token = Get-Token) -ProcessData $ProcessData -FolderId 1621959


