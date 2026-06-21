$ErrorActionPreference = "Stop"

function Invoke-FastDownload {
    param([string]$Url, [string]$OutFile)

    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $response = $request.GetResponse()
        $totalLength = $response.ContentLength
        $responseStream = $response.GetResponseStream()
        $targetStream = [System.IO.File]::Create($OutFile)
        $buffer = New-Object byte[] 65536
        $count = 0
        $downloaded = 0

        do {
            $count = $responseStream.Read($buffer, 0, $buffer.Length)
            if ($count -gt 0) {
                $targetStream.Write($buffer, 0, $count)
                $downloaded += $count
                if ($totalLength -gt 0) {
                    $percent = [math]::Round(($downloaded / $totalLength) * 100)
                    Write-Progress -Activity "Downloading Platform Tools" -Status "$percent% Complete" -PercentComplete $percent -Id 1
                }
            }
        } while ($count -gt 0)
    } finally {
        if ($targetStream) { $targetStream.Dispose() }
        if ($responseStream) { $responseStream.Dispose() }
        if ($response) { $response.Close() }
    }
    Write-Progress -Activity "Downloading Platform Tools" -Completed -Id 1
}

$url = "https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
$time = Measure-Command { Invoke-FastDownload -Url $url -OutFile "test.zip" }
Write-Host "Baseline: $($time.TotalSeconds) seconds"
