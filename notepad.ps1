#requires -Version 2
function Out-Notepad
{
  param
  (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String]
    [AllowEmptyString()] 
    $Text
  )

  begin
  {
    $sb = New-Object System.Text.StringBuilder
  }

  process
  {
    $null = $sb.AppendLine($Text)
  }
  end
  {
    $text = $sb.ToString()

    $process = Start-Process notepad -PassThru
    $null = $process.WaitForInputIdle()


    $sig = '
      [DllImport("user32.dll", EntryPoint = "FindWindowEx")]public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
      [DllImport("User32.dll")]public static extern int SendMessage(IntPtr hWnd, int uMsg, int wParam, string lParam);
    '

    $type = Add-Type -MemberDefinition $sig -Name APISendMessage -PassThru
    $hwnd = $process.MainWindowHandle
    [IntPtr]$child = $type::FindWindowEx($hwnd, [IntPtr]::Zero, "Edit", $null)
    $null = $type::SendMessage($child, 0x000C, 0, $text)
  }
}


echo "Greetings from https://outflank.nl/blog/2018/10/25/building-resilient-c2-infrastructues-using-dns
-over-https/"|Out-Notepad