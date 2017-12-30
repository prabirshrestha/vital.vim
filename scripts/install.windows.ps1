function install_vim($version, $arch) {
  if ($version -eq "latest") {
    $precursor = "http://vim-jp.org/redirects/vim/vim-win32-installer/latest/${arch}/"
    $redirect = Invoke-WebRequest -URI $precursor
    $url = $redirect.Links[0].href
  }
  else {
    $url = "https://github.com/vim/vim-win32-installer/releases/download/v${version}/gvim_${version}_${arch}.zip"
  }
  $zip = "$Env:APPVEYOR_BUILD_FOLDER\\vim.zip"
  Write-Output "URL: $url"
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:APPVEYOR_BUILD_FOLDER)
  $Env:THEMIS_VIM = "$Env:APPVEYOR_BUILD_FOLDER\\vim\\vim80\\vim.exe"
}

function install_kaoriya_vim($version, $arch) {
  if ($version -eq "latest") {
    $precursor = "http://vim-jp.org/redirects/koron/vim-kaoriya/latest/win${arch}/"
    $redirect = Invoke-WebRequest -URI $precursor
    $url = $redirect.Links[0].href
  }
  elseif($version -eq "7.4") {
    $precursor = "http://vim-jp.org/redirects/koron/vim-kaoriya/vim74/oldest/win${arch}/"
    $redirect = Invoke-WebRequest -URI $precursor
    $url = $redirect.Links[0].href
  }
  elseif($version -eq "8.0") {
    $precursor = "http://vim-jp.org/redirects/koron/vim-kaoriya/vim80/oldest/win${arch}/"
    $redirect = Invoke-WebRequest -URI $precursor
    $url = $redirect.Links[0].href
  }
  else {
    Write-Output "Unknwon version ${version} has specified."
    return
  }
  $zip = "$Env:APPVEYOR_BUILD_FOLDER\\vim.zip"
  $vim = "$Env:APPVEYOR_BUILD_FOLDER\\vim\\"
  Write-Output "URL: $url"
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $vim)
  $Env:THEMIS_VIM = $vim + (Get-ChildItem $vim).Name + '\vim.exe'
}

function install_neovim($version, $arch) {
  if ($version -eq "latest") {
    $url = "https://ci.appveyor.com/api/projects/neovim/neovim/artifacts/build/Neovim.zip?branch=master&job=Configuration%3A%20MINGW_${arch}"
  }
  else {
    $url = "https://github.com/neovim/neovim/releases/download/v${version}/nvim-win${arch}.zip"
  }
  $zip = "$Env:APPVEYOR_BUILD_FOLDER\\nvim.zip"
  Write-Output "URL: $url"
  (New-Object Net.WebClient).DownloadFile($url, $zip)
  [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
  [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $Env:APPVEYOR_BUILD_FOLDER)
  $Env:THEMIS_VIM = "$Env:APPVEYOR_BUILD_FOLDER\\Neovim\\bin\\nvim.exe"
  $Env:THEMIS_ARGS = '-e -s --headless'
}

Write-Output "**********************************************************************"
Write-Output "Vim:     $Env:VIM"
Write-Output "Version: $Env:VIM_VERSION"
Write-Output "Arch:    $Env:VIM_ARCH"
Write-Output "**********************************************************************"
if ($Env:VIM -eq "kaoriya") {
  install_kaoriya_vim $Env:VIM_VERSION $Env:VIM_ARCH
} elseif ($Env:VIM -eq "nvim") {
  install_neovim $Env:VIM_VERSION $Env:VIM_ARCH
} else {
  install_vim $Env:VIM_VERSION $Env:VIM_ARCH
}
