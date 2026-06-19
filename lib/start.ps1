# =====================================================================
#  Vercel 원클릭 키트 - 시작하기 (한국어 안내판)
#  비개발자용: 지금 무엇을 눌러야 하는지 한 줄로 알려줍니다.
#  (영어 INSTALL/RUN/UNINSTALL.bat 엔진을 한국어로 안내만 합니다.)
#  인코딩: UTF-8 (BOM), 줄바꿈: CRLF  ← PowerShell 5.1 한글 보존 필수
# =====================================================================

$ErrorActionPreference = 'SilentlyContinue'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}

$LibDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root   = Split-Path -Parent $LibDir
Set-Location $Root

# 다운로드 차단(Mark of the Web) 자동 해제 - 받은 파일이 윈도우에 막히지 않게
try { Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue } catch {}

function Has-Command([string]$name) {
    $c = Get-Command $name -ErrorAction SilentlyContinue
    return [bool]$c
}

# 새 프로그램을 깐 뒤(예: Node.js) 이 창에서도 바로 인식되도록 PATH를 새로고침
function Refresh-Path {
    try {
        $m = [Environment]::GetEnvironmentVariable('Path','Machine')
        $u = [Environment]::GetEnvironmentVariable('Path','User')
        $env:Path = (@($m,$u) | Where-Object { $_ }) -join ';'
    } catch {}
}

function Get-VercelVersion {
    if (-not (Has-Command 'vercel')) { return $null }
    $v = (& vercel --version 2>$null | Select-Object -First 1)
    return $v
}

# 로그인 여부는 설정 파일로 빠르게(오프라인) 판단합니다. (정확한 확인은 '로그인 상태 확인' 메뉴)
# Vercel 설정 위치(실측, Windows): %APPDATA%\com.vercel.cli\Data\auth.json
#   - 버전에 따라 경로가 달라질 수 있어 여러 후보를 모두 확인합니다.
#   - auth.json 안에 "token" 값이 있으면 로그인된 것으로 봅니다.
function Is-LoggedIn {
    $paths = @(
        (Join-Path $env:APPDATA      'com.vercel.cli\Data\auth.json'),
        (Join-Path $env:LOCALAPPDATA 'com.vercel.cli\Data\auth.json'),
        (Join-Path $env:APPDATA      'xdg.data\com.vercel.cli\auth.json'),
        (Join-Path $env:USERPROFILE  '.vercel\auth.json'),
        (Join-Path $env:LOCALAPPDATA 'com.vercel.cli\auth.json'),
        (Join-Path $env:APPDATA      'com.vercel.cli\auth.json')
    )
    foreach ($p in $paths) {
        if (Test-Path $p) {
            $txt = Get-Content -LiteralPath $p -Raw -ErrorAction SilentlyContinue
            if ($txt -and ($txt -match '"token"\s*:\s*"[^"]+"')) { return $true }
        }
    }
    return $false
}

function Pause-Key {
    Write-Host ''
    Write-Host '  계속하려면 아무 키나 누르세요...' -ForegroundColor DarkGray
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}

# ---------------------------------------------------------------------
#  명령 결과 '한국어 통역'
#  위쪽에 뜬 영어 결과는 그대로 두고(숨기지 않음), 그 아래에
#  "됐는지 / 안 됐는지 + 다음에 뭘 할지"를 한국어로 알려줍니다.
#  성공/실패는 방금 실행한 명령의 종료코드($LASTEXITCODE)로 판단합니다.
# ---------------------------------------------------------------------
function Explain-Result {
    param([int]$Code, [string]$Context = '')
    Write-Host ''
    Write-Host '  --------------------------------------------' -ForegroundColor DarkGray
    if ($Code -eq 0) {
        Write-Host '  [결과] 잘 됐어요!  (성공)' -ForegroundColor Green
        switch ($Context) {
            'deploy-preview' { Write-Host '   다음: 위에 뜬 임시 주소(https://...)를 복사해 브라우저 주소창에 붙여넣으면 사이트가 보여요.' -ForegroundColor Gray }
            'deploy-prod'    { Write-Host '   다음: 위에 뜬 주소가 진짜 공개 주소예요. 이제 방문자도 그 주소로 볼 수 있어요.' -ForegroundColor Gray }
            'login'          { Write-Host '   다음: 이제 [4] 인터넷에 올리기(배포) 또는 [3] 프로젝트 연결 을 할 수 있어요.' -ForegroundColor Gray }
            'whoami'         { Write-Host '   위에 보이는 이름/이메일이 지금 로그인된 계정이에요.' -ForegroundColor Gray }
            'link'           { Write-Host '   다음: 연결됐어요. 이제 [4] 배포 로 올리면 됩니다.' -ForegroundColor Gray }
            'env-pull'       { Write-Host '   다음: 이 폴더에 .env 파일로 받아졌어요.' -ForegroundColor Gray }
            'list'           { Write-Host '   위 목록이 전부예요. (아무것도 없으면 아직 만든 게 없다는 뜻)' -ForegroundColor Gray }
            default          { Write-Host '   위 내용대로 처리됐어요.' -ForegroundColor Gray }
        }
    } else {
        Write-Host '  [결과] 이번엔 안 됐어요.  (바로 위 영어 메시지가 원인이에요)' -ForegroundColor Yellow
        switch ($Context) {
            'deploy-preview' {
                Write-Host '   가장 흔한 원인: 로그인 안 됨 / 지금 폴더가 프로젝트가 아님 / 인터넷.' -ForegroundColor Gray
                Write-Host '   해보세요: 먼저 [1] 로그인 -> 다시 [4] 배포. 그래도 안 되면 [6] 내 상태 점검.' -ForegroundColor Cyan
            }
            'deploy-prod' {
                Write-Host '   가장 흔한 원인: 로그인 안 됨 / 프로젝트 미연결 / 인터넷.' -ForegroundColor Gray
                Write-Host '   해보세요: [1] 로그인 -> [3] 연결 -> 다시 시도. 그래도 안 되면 [6] 점검.' -ForegroundColor Cyan
            }
            'login' {
                Write-Host '   해보세요: 열린 브라우저 창에서 끝까지 진행했는지 확인하고, 와이파이 확인 후 다시 [1] 로그인.' -ForegroundColor Cyan
            }
            'whoami' {
                Write-Host '   로그인이 안 되어 있을 수 있어요. [1] 로그인 부터 해보세요.' -ForegroundColor Cyan
            }
            default {
                Write-Host '   해보세요: 와이파이 확인 -> 로그인 확인. 막히면 [6] 내 상태 점검 / 문제 해결 로 가세요.' -ForegroundColor Cyan
            }
        }
    }
}

# ---------------------------------------------------------------------
#  공용 메뉴: 위/아래 화살표로 고르고 Enter, 또는 번호키.
#  화살표 입력을 못 받는 환경이면 자동으로 '번호 입력' 방식으로 폴백.
# ---------------------------------------------------------------------
function Show-Menu {
    param([string]$Title, [array]$StatusLines, [array]$Items, [string]$RecKey = '1')
    $idx = 0
    for ($i = 0; $i -lt $Items.Count; $i++) { if ($Items[$i].Key -eq $RecKey) { $idx = $i; break } }

    while ($true) {
        Clear-Host
        Write-Host ''
        Write-Host '  ============================================' -ForegroundColor Cyan
        Write-Host ("     {0}" -f $Title) -ForegroundColor Cyan
        Write-Host '  ============================================' -ForegroundColor Cyan
        foreach ($s in $StatusLines) {
            if     ($s.Back)  { Write-Host $s.Text -ForegroundColor $s.Color -BackgroundColor $s.Back }
            elseif ($s.Color) { Write-Host $s.Text -ForegroundColor $s.Color }
            else              { Write-Host $s.Text }
        }
        Write-Host ''
        Write-Host '   위/아래 화살표로 고르고 Enter, 또는 번호키를 누르세요' -ForegroundColor DarkCyan
        Write-Host '  --------------------------------------------' -ForegroundColor DarkCyan
        Write-Host ''
        for ($i = 0; $i -lt $Items.Count; $i++) {
            $it = $Items[$i]
            $sel = ($i -eq $idx)
            $bullet = if ($sel) { ' > ' } else { '   ' }
            $line = ("{0}[{1}] {2}{3}" -f $bullet, $it.Key, $it.Text, $it.Mark)
            if ($sel) { Write-Host $line -ForegroundColor Black -BackgroundColor $it.Color }
            else      { Write-Host $line -ForegroundColor $it.Color }
        }
        Write-Host ''

        try {
            $k = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        } catch {
            $typed = Read-Host '   번호를 입력하고 Enter'
            if ($null -eq $typed) { $typed = '' }
            $m = $Items | Where-Object { $_.Key -eq $typed.Trim() }
            if ($m) { return $m.Key } else { continue }
        }

        $vk = $k.VirtualKeyCode
        if     ($vk -eq 38) { $idx--; if ($idx -lt 0) { $idx = $Items.Count - 1 } }   # 위 화살표
        elseif ($vk -eq 40) { $idx++; if ($idx -ge $Items.Count) { $idx = 0 } }       # 아래 화살표
        elseif ($vk -eq 13) { return $Items[$idx].Key }                               # Enter
        else {
            $ch = ("{0}" -f $k.Character).Trim()
            if ($ch -ne '') {
                $m = $Items | Where-Object { $_.Key -eq $ch }
                if ($m) { return $m.Key }
            }
        }
    }
}

# ---------------------------------------------------------------------
#  무관리자(관리자 창 없음) 휴대용 Node.js 설치
#  공식 zip을 받아 사용자 폴더에 풀고, 사용자 PATH에만 등록 → UAC 없음.
#  (winget/MSI는 관리자 허용 창을 띄우므로 쓰지 않습니다.)
# ---------------------------------------------------------------------
function Install-NodePortable {
    try {
        Write-Host ''
        Write-Host '  관리자 창 없이 설치합니다. 최신 LTS 버전을 확인하는 중...' -ForegroundColor Gray
        $idx = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json' -TimeoutSec 20
        $lts = $idx | Where-Object { $_.lts } | Select-Object -First 1
        if (-not $lts) { Write-Host '  버전 목록을 받지 못했어요.' -ForegroundColor Yellow; return $false }
        $ver  = $lts.version
        $arch = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' }
        $name = "node-$ver-win-$arch"
        $url  = "https://nodejs.org/dist/$ver/$name.zip"
        $zip  = Join-Path $env:TEMP "$name.zip"
        $dest = Join-Path $env:LOCALAPPDATA 'Programs\node-portable'

        Write-Host ("  Node.js {0} 내려받는 중... (약 30MB, 인터넷 속도에 따라 1~3분, 창 닫지 마세요)" -f $ver) -ForegroundColor Gray
        $pp = $ProgressPreference; $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $url -OutFile $zip -TimeoutSec 600
        $ProgressPreference = $pp

        Write-Host '  압축을 푸는 중...' -ForegroundColor Gray
        if (Test-Path $dest) { Remove-Item -LiteralPath $dest -Recurse -Force -ErrorAction SilentlyContinue }
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Expand-Archive -LiteralPath $zip -DestinationPath $dest -Force
        Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue

        $nodeExe = Get-ChildItem -LiteralPath $dest -Recurse -Filter 'node.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $nodeExe) { Write-Host '  압축은 풀렸는데 node.exe 를 못 찾았어요.' -ForegroundColor Yellow; return $false }
        $nodeDir = Split-Path -Parent $nodeExe.FullName

        # 사용자 PATH에만 영구 등록(관리자 불필요) + 이 창에도 즉시 반영
        $userPath = [Environment]::GetEnvironmentVariable('Path','User')
        if ($null -eq $userPath) { $userPath = '' }
        if ($userPath -notlike "*$nodeDir*") {
            $newPath = if ($userPath.Trim() -eq '') { $nodeDir } else { ($nodeDir.TrimEnd(';') + ';' + $userPath) }
            [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
        }
        $env:Path = $nodeDir + ';' + $env:Path

        if (Has-Command 'node') {
            $nv = (& node -v 2>$null)
            Write-Host ("  좋아요! Node.js {0} 설치 완료 (관리자 창 없이)." -f $nv) -ForegroundColor Green
            return $true
        }
        Write-Host '  설치는 됐지만 이 창에서는 아직 인식이 안 돼요. 창을 닫고 다시 시작하면 됩니다.' -ForegroundColor Yellow
        return $true
    } catch {
        Write-Host ('  자동 설치 중 문제가 생겼어요: ' + $_.Exception.Message) -ForegroundColor Yellow
        return $false
    }
}

# ---------------------------------------------------------------------
#  Node.js 없을 때: 무관리자 자동 설치(추천) 또는 직접 받기 안내
# ---------------------------------------------------------------------
function Install-Node {
    Write-Host ''
    Write-Host '  [필수 부품] Node.js 가 이 컴퓨터에 없습니다.' -ForegroundColor Yellow
    Write-Host '  Vercel을 깔려면 Node.js가 먼저 있어야 해요.' -ForegroundColor Gray
    Write-Host ''
    Write-Host '   방법 1) 자동 설치 (관리자 창 없이, 휴대용) - 추천' -ForegroundColor Green
    Write-Host '   방법 2) 직접 받기 (nodejs.org 열기) - 항상 됨' -ForegroundColor White
    Write-Host ''
    $ans = Read-Host '  방법 1로 자동 설치할까요?  (Y=자동(추천) / N=직접 받기)'
    if ($null -eq $ans) { $ans = '' }

    if ($ans.Trim() -match '^[Yy]') {
        $ok = Install-NodePortable
        if ($ok) {
            Write-Host '  이어서 [1] 설치하기 를 한 번 더 누르면 Vercel이 깔립니다.' -ForegroundColor Cyan
            Write-Host '  (혹시 인식이 안 되면 이 창을 닫고 시작하기.bat 을 다시 더블클릭하세요.)' -ForegroundColor Gray
        } else {
            Write-Host ''
            Write-Host '  자동 설치가 안 돼서, 가장 확실한 직접 받기로 안내할게요.' -ForegroundColor Yellow
            Start-Process 'https://nodejs.org/'
            Write-Host '  초록색 LTS 버튼 -> 받은 파일 실행 -> 설치 -> 이 창 닫고 [시작하기.bat] 다시 시작.' -ForegroundColor Gray
        }
    } else {
        Start-Process 'https://nodejs.org/'
        Write-Host ''
        Write-Host '  브라우저에서 초록색 LTS 버튼을 눌러 받은 뒤 설치하세요.' -ForegroundColor Gray
        Write-Host '  설치 후 이 창을 닫고 [시작하기.bat]을 다시 더블클릭하세요.' -ForegroundColor Gray
    }
    Pause-Key
}

# ---------------------------------------------------------------------
#  안전한 배포: 폴더가 웹사이트인지 먼저 확인 + 미리보기/진짜공개 분리 + YES 게이트
#  (배포는 되돌리기 어려운 '공개'라, 엉뚱한 폴더 공개를 막는 것이 핵심)
# ---------------------------------------------------------------------
function Invoke-Deploy {
    # 로그인 확인(소프트): 못 찾아도 막지는 않음 - 경로가 버전마다 달라 오탐 가능
    if (-not (Is-LoggedIn)) {
        Write-Host ''
        Write-Host '  [확인] 로그인이 아직 확인되지 않았어요.' -ForegroundColor Yellow
        Write-Host '  먼저 [1] 로그인 을 하는 것을 권합니다. (안 했으면 배포 중 로그인 창이 뜰 수 있어요.)' -ForegroundColor Gray
        $go = Read-Host '  그래도 계속할까요?  (Y=계속 / N=취소)'
        if ($null -eq $go) { $go = '' }
        if ($go.Trim() -notmatch '^[Yy]') { Write-Host '  배포를 취소했습니다.' -ForegroundColor Gray; Pause-Key; return }
    }

    # 1) 배포할 폴더 정하기 - 웹사이트 파일이 있는지 확인 (이 키트 폴더엔 보통 없음)
    $target = $Root
    $marks = @('index.html','vercel.json','package.json','next.config.js','next.config.mjs','dist','public','build','out')
    $looksWeb = $false
    foreach ($m in $marks) { if (Test-Path (Join-Path $target $m)) { $looksWeb = $true; break } }

    if (-not $looksWeb) {
        Write-Host ''
        Write-Host '  [확인] 지금 폴더에는 웹사이트/프로젝트 파일이 안 보입니다.' -ForegroundColor Yellow
        Write-Host ('         폴더: {0}' -f $target) -ForegroundColor DarkGray
        Write-Host '  배포는 "내 프로젝트 파일이 있는 폴더"에서 해야 합니다.' -ForegroundColor Yellow
        Write-Host ''
        Write-Host '  프로젝트 폴더를 끌어다 놓거나 경로를 붙여넣고 Enter.' -ForegroundColor Gray
        Write-Host '  (그냥 Enter 치면 취소합니다.)' -ForegroundColor Gray
        $p = Read-Host '  프로젝트 폴더 경로'
        if ($null -eq $p) { $p = '' }
        $p = $p.Trim().Trim('"')
        if ($p -eq '') { Write-Host '  배포를 취소했습니다.' -ForegroundColor Gray; Pause-Key; return }
        if (-not (Test-Path $p)) { Write-Host '  그 폴더를 찾을 수 없어요. 경로를 다시 확인해주세요.' -ForegroundColor Yellow; Pause-Key; return }
        $target = $p
    }

    # 1-2) 폴더 한 번 더 확인 - 엉뚱한 폴더를 인터넷에 올리는 사고를 막습니다.
    while ($true) {
        $found = @()
        foreach ($m in $marks) { if (Test-Path (Join-Path $target $m)) { $found += $m } }
        Write-Host ''
        Write-Host '  [배포할 폴더 확인]' -ForegroundColor Cyan
        Write-Host ('   폴더 : {0}' -f $target) -ForegroundColor White
        if ($found.Count -gt 0) { Write-Host ('   안에 있는 것 : {0}' -f ($found -join ', ')) -ForegroundColor DarkGray }
        else                    { Write-Host '   안에 웹 프로젝트 파일이 잘 안 보여요. (그래도 올릴 순 있어요)' -ForegroundColor Yellow }
        Write-Host ''
        $ok = Read-Host '  이 폴더가 맞나요?  (Y=맞음, 계속 / N=다른 폴더 / Enter=취소)'
        if ($null -eq $ok) { $ok = '' }
        $ok = $ok.Trim()
        if ($ok -eq '') { Write-Host '  배포를 취소했습니다.' -ForegroundColor Gray; Pause-Key; return }
        if ($ok -match '^[Yy]') { break }
        if ($ok -match '^[Nn]') {
            $p2 = Read-Host '  다른 폴더 경로를 붙여넣고 Enter (그냥 Enter=취소)'
            if ($null -eq $p2) { $p2 = '' }
            $p2 = $p2.Trim().Trim('"')
            if ($p2 -eq '') { Write-Host '  배포를 취소했습니다.' -ForegroundColor Gray; Pause-Key; return }
            if (-not (Test-Path $p2)) { Write-Host '  그 폴더를 찾을 수 없어요. 다시 확인해주세요.' -ForegroundColor Yellow; continue }
            $target = $p2
            continue
        }
    }

    # 2) 미리보기 vs 진짜 공개 선택  (기본 커서는 항상 '안전한 미리보기'에)
    $dStatus = @(
        @{ Text = '' },
        @{ Text = ('  배포할 폴더: {0}' -f $target); Color = 'DarkCyan' },
        @{ Text = '  기본은 안전한 [1] 미리보기 예요. 진짜 공개는 YES 를 입력해야만 됩니다.'; Color = 'Gray' },
        @{ Text = '' }
    )
    $dItems = @(
        @{ Key = '1'; Text = '미리보기 배포   (임시 주소, 진짜 사이트는 그대로 - 안전)'; Color = 'Green';    Mark = '   <- 추천' },
        @{ Key = '2'; Text = '진짜 공개 배포  (production - 방문자가 바로 보게 됨)';      Color = 'Red';      Mark = '' },
        @{ Key = '0'; Text = '취소'; Color = 'DarkGray'; Mark = '' }
    )
    $d = Show-Menu -Title 'Vercel - 인터넷에 올리기 (배포)' -StatusLines $dStatus -Items $dItems -RecKey '1'
    if ($null -eq $d) { $d = '' }

    switch ($d.Trim()) {
        '1' {
            Write-Host ''
            Write-Host '  미리보기로 올립니다. 임시 주소(Preview URL)가 나오면 그 주소로 확인하세요.' -ForegroundColor Gray
            Write-Host '  (처음이면 몇 가지 질문이 나옵니다 - 보통 Enter로 기본값 진행.)' -ForegroundColor Gray
            Write-Host ''
            Push-Location $target
            & vercel
            $rc = $LASTEXITCODE
            Pop-Location
            Explain-Result -Code $rc -Context 'deploy-preview'
            Pause-Key
        }
        '2' {
            Write-Host ''
            Write-Host '  *** 주의: 진짜 공개 배포 (production) ***' -ForegroundColor Red
            Write-Host '  지금 폴더의 내용이 인터넷에 공개되어 방문자가 바로 보게 됩니다.' -ForegroundColor Yellow
            Write-Host ('  폴더: {0}' -f $target) -ForegroundColor DarkGray
            Write-Host ''
            $yes = Read-Host '  정말 공개하려면  YES  를 입력하세요 (대소문자 상관없음)'
            if ($null -eq $yes) { $yes = '' }
            if ($yes.Trim().ToUpper() -ne 'YES') { Write-Host '  취소했습니다. (YES 라고 정확히 입력해야 진행돼요 - 안전을 위해서예요)' -ForegroundColor Gray; Pause-Key; return }
            Write-Host ''
            Write-Host '  진짜 공개 배포를 진행합니다...' -ForegroundColor Yellow
            Push-Location $target
            & vercel --prod
            $rc = $LASTEXITCODE
            Pop-Location
            Explain-Result -Code $rc -Context 'deploy-prod'
            Pause-Key
        }
        default { return }
    }
}

# ---------------------------------------------------------------------
#  내 상태 점검 / 문제 해결 (오류 대처를 메뉴 안에서 바로)
# ---------------------------------------------------------------------
function Show-Diagnosis {
    while ($true) {
        Refresh-Path
        $hasNode = Has-Command 'node'
        $hasVc   = Has-Command 'vercel'
        $logged  = $false
        if ($hasVc) { $logged = Is-LoggedIn }
        $net = $false
        try { $net = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet -ErrorAction SilentlyContinue } catch { $net = $false }

        $status = @()
        $status += @{ Text = '' }
        $status += @{ Text = '  [내 상태 점검]' }
        if ($hasNode) { $status += @{ Text = '   - Node.js (필수 부품)   : 있음  [OK]'; Color = 'Green' } }
        else          { $status += @{ Text = '   - Node.js (필수 부품)   : 없음  [설치 필요]'; Color = 'Yellow' } }
        if ($hasVc)   { $status += @{ Text = '   - Vercel CLI            : 있음  [OK]'; Color = 'Green' } }
        else          { $status += @{ Text = '   - Vercel CLI            : 없음  [설치 필요]'; Color = 'Yellow' } }
        if ($hasVc) {
            if ($logged) { $status += @{ Text = '   - Vercel 로그인         : 되어 있음  [OK]'; Color = 'Green' } }
            else         { $status += @{ Text = '   - Vercel 로그인         : 확인 안 됨  [로그인 필요]'; Color = 'Yellow' } }
        }
        if ($net) { $status += @{ Text = '   - 인터넷 연결           : 됨  [OK]'; Color = 'Green' } }
        else      { $status += @{ Text = '   - 인터넷 연결           : 확인 안 됨  [와이파이 확인]'; Color = 'Yellow' } }
        $status += @{ Text = '' }
        # 진단 결론 한 줄 - 지금 가장 먼저 할 것 하나만 콕 집어줍니다.
        if     (-not $net)     { $status += @{ Text = '  >> 진단: 인터넷이 안 잡혀요. 와이파이부터 확인하세요.'; Color = 'White'; Back = 'DarkRed' } }
        elseif (-not $hasNode) { $status += @{ Text = '  >> 진단: Node.js가 없어요. [0] 뒤로 -> [1] 설치하기 부터.'; Color = 'White'; Back = 'DarkGreen' } }
        elseif (-not $hasVc)   { $status += @{ Text = '  >> 진단: Vercel이 없어요. [0] 뒤로 -> [1] 설치하기 를 누르세요.'; Color = 'White'; Back = 'DarkGreen' } }
        elseif (-not $logged)  { $status += @{ Text = '  >> 진단: 로그인만 하면 돼요. [0] 뒤로 -> [2] 사용하기 -> 로그인.'; Color = 'White'; Back = 'DarkGreen' } }
        else                   { $status += @{ Text = '  >> 진단: 다 정상이에요! 바로 배포할 수 있어요.'; Color = 'White'; Back = 'DarkGreen' } }
        $status += @{ Text = '' }
        $status += @{ Text = '  [자주 나오는 문제 -> 해결법]'; Color = 'Cyan' }
        $status += @{ Text = '   · 파란 경고(SmartScreen)  -> "추가 정보" -> "실행"'; Color = 'Gray' }
        $status += @{ Text = '   · 설치가 자꾸 실패        -> 백신 10분 끄고 다시 / 와이파이 확인'; Color = 'Gray' }
        $status += @{ Text = '   · vercel 을 못 찾는다고 함 -> 이 창 닫고 시작하기.bat 다시 실행'; Color = 'Gray' }
        $status += @{ Text = '   · 검은 영어 창이 무섭다    -> 진행 중이란 뜻, 닫지만 마세요'; Color = 'Gray' }

        $items = @(
            @{ Key = '1'; Text = '파일 차단 풀기 (Unblock) 다시 실행'; Color = 'White';    Mark = '' },
            @{ Key = '2'; Text = '왕초보 가이드 열기';                 Color = 'White';    Mark = '' },
            @{ Key = '3'; Text = '상태 다시 확인 (새로고침)';          Color = 'White';    Mark = '   <- 추천' },
            @{ Key = '4'; Text = '로그인 정확히 확인  (vercel whoami)'; Color = 'White';   Mark = '' },
            @{ Key = '0'; Text = '뒤로';                               Color = 'DarkGray'; Mark = '' }
        )

        $c = Show-Menu -Title 'Vercel - 내 상태 점검 / 문제 해결' -StatusLines $status -Items $items -RecKey '3'
        if ($null -eq $c) { $c = '' }

        switch ($c.Trim()) {
            '1' {
                Write-Host ''
                Write-Host '  이 폴더의 파일들에 걸린 윈도우 차단을 풉니다...' -ForegroundColor Gray
                try { Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue } catch {}
                Write-Host '  완료했습니다.' -ForegroundColor Green
                Pause-Key
            }
            '2' {
                $guide = Join-Path $Root '왕초보가이드.md'
                if (Test-Path $guide) { Start-Process $guide }
                else { Start-Process (Join-Path $Root 'README.md') }
                Pause-Key
            }
            '3' { }  # 루프가 자동으로 상태를 다시 점검
            '4' {
                Write-Host ''
                if (-not (Has-Command 'vercel')) {
                    Write-Host '  아직 Vercel이 설치되지 않았어요. [0] 뒤로 -> [1] 설치하기 부터 하세요.' -ForegroundColor Yellow
                } else {
                    Write-Host '  ==== 로그인 정확히 확인 (서버에 직접 물어봅니다) ====' -ForegroundColor Cyan
                    Write-Host ''
                    & vercel whoami
                    Explain-Result -Code $LASTEXITCODE -Context 'whoami'
                }
                Pause-Key
            }
            '0' { return }
            default {
                Write-Host ''
                Write-Host '  그 번호는 메뉴에 없어요. 0~4 중에서 골라주세요.' -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
        }
    }
}

# ---------------------------------------------------------------------
#  [고급] 자주 쓰는 고급 작업을 '한국어로 바로' 실행. (영어 RUN.bat 창 안 띄움)
#  도메인/환경변수/로그/목록/승격/롤백 등. 드물거나 위험한 명령
#  (삭제/별칭/DNS/초기화)은 [T] 전체 메뉴(분류별)로 안내.
# ---------------------------------------------------------------------
function Use-Advanced {
    while ($true) {
        $status = @()
        $status += @{ Text = '' }
        $status += @{ Text = '  자주 쓰는 고급 작업을 한국어로 바로 실행합니다.'; Color = 'Gray' }
        $status += @{ Text = '  더 많은 기능(삭제/별칭/DNS/초기화 등)은 [T] 전체 목록에 있어요.'; Color = 'DarkGray' }
        $status += @{ Text = '' }

        $items = @(
            @{ Key = '1'; Text = '배포 목록 보기         (내 배포들 한눈에)';              Color = 'White';    Mark = '' },
            @{ Key = '2'; Text = '배포 로그 보기         (문제 원인 찾기)';                Color = 'White';    Mark = '' },
            @{ Key = '3'; Text = '환경변수 목록          (등록된 비밀값 보기)';            Color = 'White';    Mark = '' },
            @{ Key = '4'; Text = '환경변수 추가          (API 키 등 등록)';                Color = 'White';    Mark = '' },
            @{ Key = '5'; Text = '환경변수 .env로 받기   (내 컴퓨터로 내려받기)';          Color = 'White';    Mark = '' },
            @{ Key = '6'; Text = '도메인 목록            (내 주소들 보기)';                Color = 'White';    Mark = '' },
            @{ Key = '7'; Text = '도메인 추가            (새 주소 연결)';                  Color = 'White';    Mark = '' },
            @{ Key = '8'; Text = '미리보기 -> 공개 승격  (preview를 production으로)';       Color = 'White';    Mark = '' },
            @{ Key = '9'; Text = '이전 버전으로 되돌리기 (rollback)';                      Color = 'White';    Mark = '' },
            @{ Key = 'U'; Text = 'Vercel 최신으로 업데이트 (가끔 한 번, 관리자 창 없음)';   Color = 'White';    Mark = '' },
            @{ Key = 'T'; Text = '전체 메뉴 열기 (분류별 한국어, 모든 기능)'; Color = 'White';    Mark = '' },
            @{ Key = '0'; Text = '뒤로'; Color = 'DarkGray'; Mark = '' }
        )

        $c = Show-Menu -Title 'Vercel - 고급 기능 (자주 쓰는 작업)' -StatusLines $status -Items $items -RecKey '1'
        if ($null -eq $c) { $c = '' }

        switch ($c.Trim().ToUpper()) {
            '1' { Write-Host ''; Write-Host '  ==== 배포 목록 ====' -ForegroundColor Cyan; Write-Host ''; & vercel ls; Explain-Result -Code $LASTEXITCODE -Context 'list'; Pause-Key }
            '2' {
                Write-Host ''
                $u = Read-Host '  로그를 볼 배포 주소(URL)를 붙여넣고 Enter (그냥 Enter=취소)'
                if ($null -eq $u) { $u = '' }
                if ($u.Trim() -ne '') { & vercel logs $u.Trim(); Explain-Result -Code $LASTEXITCODE -Context 'list' }
                Pause-Key
            }
            '3' { Write-Host ''; Write-Host '  ==== 환경변수 목록 ====' -ForegroundColor Cyan; Write-Host ''; & vercel env ls; Explain-Result -Code $LASTEXITCODE -Context 'list'; Pause-Key }
            '4' { Write-Host ''; Write-Host '  안내(질문)에 따라 환경변수를 추가합니다.' -ForegroundColor Gray; Write-Host ''; & vercel env add; Explain-Result -Code $LASTEXITCODE -Context ''; Pause-Key }
            '5' { Write-Host ''; Write-Host '  환경변수를 .env 파일로 내려받습니다.' -ForegroundColor Gray; Write-Host ''; & vercel env pull; Explain-Result -Code $LASTEXITCODE -Context 'env-pull'; Pause-Key }
            '6' { Write-Host ''; Write-Host '  ==== 도메인 목록 ====' -ForegroundColor Cyan; Write-Host ''; & vercel domains ls; Explain-Result -Code $LASTEXITCODE -Context 'list'; Pause-Key }
            '7' {
                Write-Host ''
                $d = Read-Host '  추가할 도메인 이름을 입력 (그냥 Enter=취소)'
                if ($null -eq $d) { $d = '' }
                if ($d.Trim() -ne '') { & vercel domains add $d.Trim(); Explain-Result -Code $LASTEXITCODE -Context '' }
                Pause-Key
            }
            '8' {
                Write-Host ''
                $u = Read-Host '  공개로 승격할 배포 주소(URL) 입력 (그냥 Enter=취소)'
                if ($null -eq $u) { $u = '' }
                if ($u.Trim() -ne '') { & vercel promote $u.Trim(); Explain-Result -Code $LASTEXITCODE -Context '' }
                Pause-Key
            }
            '9' {
                Write-Host ''
                $u = Read-Host '  되돌릴(이전) 배포 주소(URL) 입력 (그냥 Enter=취소)'
                if ($null -eq $u) { $u = '' }
                if ($u.Trim() -ne '') { & vercel rollback $u.Trim(); Explain-Result -Code $LASTEXITCODE -Context '' }
                Pause-Key
            }
            'U' {
                Write-Host ''
                Write-Host '  ==== Vercel 최신으로 업데이트 ====' -ForegroundColor Cyan
                Write-Host '  최신 버전을 설치합니다. (관리자 창 없이, 보통 1~2분)' -ForegroundColor Gray
                Write-Host ''
                & npm install -g vercel@latest
                Explain-Result -Code $LASTEXITCODE -Context ''
                Pause-Key
            }
            'T' {
                Start-Process -FilePath (Join-Path $Root 'RUN.bat')
                Write-Host ''
                Write-Host '  전체 메뉴 창을 열었습니다. 분류를 고른 뒤 세부 기능을 고르세요.' -ForegroundColor Gray
                Write-Host '  (예: 환경변수 -> 삭제 / 도메인 -> 삭제·별칭·DNS / 고급 -> 새 프로젝트)' -ForegroundColor Gray
                Pause-Key
            }
            '0' { return }
            default {
                Write-Host ''
                Write-Host '  그 항목은 메뉴에 없어요. 화살표로 고르거나 번호/문자를 눌러주세요.' -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
        }
    }
}

# ---------------------------------------------------------------------
#  [2] 사용하기 -> 한국어 '자주 쓰는 작업' 메뉴
# ---------------------------------------------------------------------
function Use-QuickActions {
    while ($true) {
        $logged = Is-LoggedIn

        $status = @()
        $status += @{ Text = '' }
        if ($logged) { $status += @{ Text = '  로그인: 되어 있음  [OK]'; Color = 'Green' } }
        else         { $status += @{ Text = '  로그인: 확인 안 됨  (먼저 [1] 로그인 권장)'; Color = 'Yellow' } }
        $status += @{ Text = '' }
        if ($logged) { $status += @{ Text = '  >> 준비됐어요! [4] 인터넷에 올리기(배포) 또는 [3] 프로젝트 연결.'; Color = 'White'; Back = 'DarkGreen' } }
        else         { $status += @{ Text = '  >> 지금 할 일: [1] 로그인 부터 하세요.'; Color = 'White'; Back = 'DarkGreen' } }

        $recSub = if ($logged) { '4' } else { '1' }
        $cLogin = if (-not $logged) { 'Green' } else { 'Gray' }
        $cAct   = if ($logged) { 'White' } else { 'Gray' }
        $items = @(
            @{ Key = '1'; Text = '로그인              (브라우저로 Vercel 계정 연결)'; Color = $cLogin;  Mark = $(if ($recSub -eq '1') { '   <- 지금 이것!' } else { '' }) },
            @{ Key = '2'; Text = '로그인 상태 확인     (내 계정 보기)'; Color = 'White'; Mark = '' },
            @{ Key = '3'; Text = '프로젝트 연결        (이 폴더를 Vercel과 연결)'; Color = 'White'; Mark = '' },
            @{ Key = '4'; Text = '인터넷에 올리기 (배포) (폴더 확인 + 미리보기/공개 안내)'; Color = $cAct; Mark = $(if ($recSub -eq '4') { '   <- 추천' } else { '' }) },
            @{ Key = '5'; Text = '고급 기능             (도메인/환경변수/로그/승격 등)'; Color = 'White'; Mark = '' },
            @{ Key = '0'; Text = '뒤로'; Color = 'DarkGray'; Mark = '' }
        )

        $c = Show-Menu -Title 'Vercel - 자주 쓰는 작업' -StatusLines $status -Items $items -RecKey $recSub
        if ($null -eq $c) { $c = '' }

        switch ($c.Trim()) {
            '1' {
                Write-Host ''
                Write-Host '  인터넷 브라우저가 열립니다. 거기서 로그인 / 권한 허용 하세요.' -ForegroundColor Gray
                Write-Host '  (브라우저에서 끝내면 이 창으로 돌아옵니다.)' -ForegroundColor Gray
                Write-Host ''
                & vercel login
                Explain-Result -Code $LASTEXITCODE -Context 'login'
                Pause-Key
            }
            '2' {
                Write-Host ''
                Write-Host '  ==== 내 계정 (로그인 상태) ====' -ForegroundColor Cyan
                Write-Host ''
                & vercel whoami
                Explain-Result -Code $LASTEXITCODE -Context 'whoami'
                Pause-Key
            }
            '3' {
                Write-Host ''
                Write-Host '  ==== 프로젝트 연결 ====' -ForegroundColor Cyan
                Write-Host '  이 폴더를 Vercel 프로젝트와 연결합니다. 질문이 나오면 보통 Enter로 진행.' -ForegroundColor Gray
                Write-Host ''
                & vercel link
                Explain-Result -Code $LASTEXITCODE -Context 'link'
                Pause-Key
            }
            '4' {
                Invoke-Deploy
            }
            '5' {
                Use-Advanced
            }
            '0' { return }
            default {
                Write-Host ''
                Write-Host '  그 번호는 메뉴에 없어요. 0~5 중에서 골라주세요.' -ForegroundColor Yellow
                Start-Sleep -Seconds 2
            }
        }
    }
}

# =====================================================================
#  메인 메뉴
# =====================================================================
$running = $true
while ($running) {
    Refresh-Path
    $hasNode = Has-Command 'node'
    $hasVc   = Has-Command 'vercel'
    $vcVer   = Get-VercelVersion
    $logged  = $false
    if ($hasVc) { $logged = Is-LoggedIn }

    # 상태 표시 줄
    $status = @()
    $status += @{ Text = '' }
    $status += @{ Text = '  [지금 내 컴퓨터 상태]' }
    if ($hasNode) { $status += @{ Text = '   - Node.js (필수 부품)   : 있음  [OK]'; Color = 'Green' } }
    else          { $status += @{ Text = '   - Node.js (필수 부품)   : 없음  [설치 필요]'; Color = 'Yellow' } }
    if ($hasVc)   { $status += @{ Text = ("   - Vercel CLI            : 있음 ({0})  [OK]" -f $vcVer); Color = 'Green' } }
    else          { $status += @{ Text = '   - Vercel CLI            : 없음  [설치 필요]'; Color = 'Yellow' } }
    if ($hasVc) {
        if ($logged) { $status += @{ Text = '   - Vercel 로그인         : 되어 있음  [OK]'; Color = 'Green' } }
        else         { $status += @{ Text = '   - Vercel 로그인         : 확인 안 됨  [로그인 필요]'; Color = 'Yellow' } }
    }
    $status += @{ Text = '' }
    # 지금 할 일 한 줄 (가장 중요)
    if (-not $hasNode) {
        $status += @{ Text = '  >> 지금 할 일: [1] 설치하기 (Node.js 부터 자동 안내).'; Color = 'White'; Back = 'DarkGreen' }
    } elseif (-not $hasVc) {
        $status += @{ Text = '  >> 지금 할 일: [1] 설치하기 를 누르세요.'; Color = 'White'; Back = 'DarkGreen' }
    } elseif (-not $logged) {
        $status += @{ Text = '  >> 지금 할 일: [2] 사용하기 -> 로그인 부터.'; Color = 'White'; Back = 'DarkGreen' }
    } else {
        $status += @{ Text = '  >> 준비 끝! [2] 사용하기 로 들어가면 됩니다.'; Color = 'White'; Back = 'DarkGreen' }
    }
    $status += @{ Text = '  (막히면 언제든 [6] 내 상태 점검 / 문제 해결)'; Color = 'DarkGray' }

    if (-not $hasVc) { $recKey = '1' } else { $recKey = '2' }
    $cInstall = if (-not $hasVc) { 'Green' } else { 'Gray' }
    $cUse     = if ($hasVc)      { 'Green' } else { 'Gray' }

    $items = @(
        @{ Key = '1'; Text = '설치하기      (Vercel CLI를 컴퓨터에 깔기)';     Color = $cInstall;  Mark = $(if ($recKey -eq '1') { '   <- 지금 이것!' } else { '' }) },
        @{ Key = '2'; Text = '사용하기      (로그인 / 연결 / 배포)';           Color = $cUse;      Mark = $(if ($recKey -eq '2') { '   <- 지금 이것!' } else { '' }) },
        @{ Key = '3'; Text = '제거하기      (깨끗이 지우기, 내 코드는 안 지움)'; Color = 'Red';      Mark = '   (주의)' },
        @{ Key = '4'; Text = '사용설명서    (왕초보 가이드 열기)';             Color = 'White';    Mark = '' },
        @{ Key = '5'; Text = 'Vercel 대시보드(내 프로젝트 관리) 열기';         Color = 'White';    Mark = '' },
        @{ Key = '6'; Text = '내 상태 점검 / 문제 해결  (막혔을 때 여기!)';    Color = 'White';    Mark = '' },
        @{ Key = '0'; Text = '끝내기';                                         Color = 'DarkGray'; Mark = '' }
    )

    $choice = Show-Menu -Title 'Vercel 원클릭 키트 - 시작하기' -StatusLines $status -Items $items -RecKey $recKey
    if ($null -eq $choice) { $choice = '' }

    switch ($choice.Trim()) {
        '1' {
            if (-not $hasNode) {
                Install-Node
            } else {
                Write-Host ''
                Write-Host '  설치 창을 엽니다. 검은 창이 영어로 떠도 놀라지 마세요 - 그대로 진행됩니다.' -ForegroundColor Gray
                Write-Host '  이미 설치돼 있으면 묻지 않고 바로 끝나요. (업데이트는 RUN.bat [10] 도구 -> 2)' -ForegroundColor Gray
                Write-Host '  관리자 허용 창은 뜨지 않습니다. (혹시 권한 오류가 나면 그때만 INSTALL.bat 우클릭 -> 관리자 권한으로 실행)' -ForegroundColor Gray
                Start-Process -FilePath (Join-Path $Root 'INSTALL.bat')
                Write-Host ''
                Write-Host '  설치가 끝나면 이 창으로 돌아와 아무 키나 누르세요. 상태를 다시 확인합니다.' -ForegroundColor Gray
                Pause-Key
            }
        }
        '2' {
            if (-not $hasVc) {
                Write-Host ''
                Write-Host '  아직 설치가 안 되어 있어요. 먼저 [1] 설치하기 부터 해주세요.' -ForegroundColor Yellow
                Pause-Key
            } else {
                Use-QuickActions
            }
        }
        '3' {
            Write-Host ''
            Write-Host '  제거 창을 엽니다. 정말 지울지 한 번 더 물어봅니다(YES 입력).' -ForegroundColor Gray
            Start-Process -FilePath (Join-Path $Root 'UNINSTALL.bat')
            Pause-Key
        }
        '4' {
            $guide = Join-Path $Root '왕초보가이드.md'
            if (Test-Path $guide) { Start-Process $guide }
            else { Start-Process (Join-Path $Root 'README.md') }
            Pause-Key
        }
        '5' {
            Start-Process 'https://vercel.com/dashboard'
            Pause-Key
        }
        '6' {
            Show-Diagnosis
        }
        '0' { $running = $false }
        default {
            Write-Host ''
            Write-Host '  그 번호는 메뉴에 없어요. 0~6 중에서 골라주세요.' -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
}

Clear-Host
Write-Host ''
Write-Host '  안녕히 가세요! 좋은 하루 되세요.' -ForegroundColor Cyan
Write-Host ''
Start-Sleep -Seconds 1
