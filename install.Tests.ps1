$mockCode = @"
using System;
using System.IO;
using System.Net;

#pragma warning disable SYSLIB0014
public class MockWebRequestCreate : IWebRequestCreate {
    public WebRequest Create(Uri uri) {
        return new MockWebRequest();
    }
}

public class MockWebRequest : WebRequest {
    public override WebResponse GetResponse() {
        return new MockWebResponse();
    }
}

public class MockWebResponse : WebResponse {
    public override long ContentLength { get { return 100; } }
    public override Stream GetResponseStream() {
        byte[] data = new byte[100];
        for(int i=0; i<100; i++) data[i] = (byte)i;
        return new MemoryStream(data);
    }
}
#pragma warning restore SYSLIB0014
"@

Add-Type -TypeDefinition $mockCode

Describe "Invoke-FastDownload" {
    BeforeAll {
        function Read-Host { return '3' }
        . "$PSScriptRoot/install.ps1"
    }

    It "should download the stream correctly using a mocked WebRequest" {
        $tempFile = New-TemporaryFile

        [System.Net.WebRequest]::RegisterPrefix("mock", [MockWebRequestCreate]::new())

        Invoke-FastDownload -Url "mock://test" -OutFile $tempFile.FullName

        $fileInfo = Get-Item $tempFile.FullName
        $fileInfo.Length | Should -Be 100

        Remove-Item $tempFile.FullName
    }
}
