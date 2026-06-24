BeforeAll {
    # Mock the interactive parts of the script to prevent pausing and clearing the screen
    Mock Clear-Host {}
    Mock Read-Host { return '3' }
    Mock Write-Host {}
    Mock Write-Progress {}

    # Source the script
    . "$PSScriptRoot/install.ps1"
}

Describe "Invoke-FastDownload" {
    It "should download a file successfully using file:// uri" {
        # Setup
        $sourceFile = New-TemporaryFile
        $targetFile = New-TemporaryFile

        $testContent = "This is a test content for downloading."
        Set-Content -Path $sourceFile.FullName -Value $testContent -NoNewline

        $url = "file://" + $sourceFile.FullName

        # Action
        Invoke-FastDownload -Url $url -OutFile $targetFile.FullName

        # Assert
        $downloadedContent = Get-Content -Path $targetFile.FullName -Raw
        $downloadedContent | Should -Be $testContent

        # Cleanup
        Remove-Item -Path $sourceFile.FullName -Force
        Remove-Item -Path $targetFile.FullName -Force
    }

    It "should throw an error for invalid URLs" {
        # Setup
        $targetFile = New-TemporaryFile
        $url = "invalid://url"

        # Action & Assert
        { Invoke-FastDownload -Url $url -OutFile $targetFile.FullName } | Should -Throw

        # Cleanup
        Remove-Item -Path $targetFile.FullName -Force
    }

    It "should clean up file locks when an error occurs" {
        # Setup
        $targetFile = New-TemporaryFile
        $url = "http://localhost:65535/nonexistent" # A URL that will fail

        # Action
        { Invoke-FastDownload -Url $url -OutFile $targetFile.FullName } | Should -Throw

        # Assert
        # The file shouldn't be locked; we can write to it
        { Set-Content -Path $targetFile.FullName -Value "New Content" } | Should -Not -Throw

        # Cleanup
        Remove-Item -Path $targetFile.FullName -Force
    }
}
