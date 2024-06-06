clear

$mode = $args[0]
$identifier = $args[1]
$record_name = $args[2]
$token = $args[3]

Get-Content .env | foreach {
  $name, $value = $_.split('=')
  if ([string]::IsNullOrWhiteSpace($name) -or $name.Contains('#')) {
    continue
  }
  Set-Content env:\$name $value
}

$base = 'https://api.cloudflare.com/client/v4'
$zone_id = $env:ZONE_ID
$access_token = $env:ACCESS_TOKEN

$headers=@{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Bearer $access_token")

echo "starting $mode mode"
echo $identifier
echo $record_name
echo $token

try {
	if ($mode -eq 'create') {
		$body = "{
			`"type`": `"TXT`",
			`"name`": `"$record_name`",
			`"content`": `"$token`",
			`"ttl`": 60
		}"
        Invoke-RestMethod -Uri "$base/zones/$zone_id/dns_records" -Method POST -Headers $headers -Body $body | convertto-json -depth 100 | echo
	} elseif ($mode -eq 'delete') {
		$record = (Invoke-RestMethod -Uri "$base/zones/$zone_id/dns_records" -Method GET -Headers $headers | convertto-json -depth 100 | ConvertFrom-Json).result | where { $_.content -eq $token }
		Invoke-RestMethod -Uri "$base/zones/$zone_id/dns_records/$($record.id)" -Method DELETE -Headers $headers | convertto-json -depth 100 | echo
	} else {
		echo 'invalid mode'
	}
} catch {
	$reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
	$reader.BaseStream.Position = 0
	$reader.DiscardBufferedData()
	
	echo $reader.ReadToEnd();
}
