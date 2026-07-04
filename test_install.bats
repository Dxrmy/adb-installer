#!/usr/bin/env bats

setup() {
  source ./install.sh

  export MOCK_DIR="$(mktemp -d)"
  export HOME="$MOCK_DIR/home"
  mkdir -p "$HOME"

  export INSTALL_DIR="$HOME/.adb"
  export BIN_DIR="$INSTALL_DIR/platform-tools"
  export ZIP_PATH="$HOME/platform-tools.zip"

  # create dummy profile files to test the PATH export
  touch "$HOME/.bashrc"
}

teardown() {
  rm -rf "$MOCK_DIR"
}

curl() {
  echo "MOCK CURL: $*" >> "$MOCK_DIR/curl.log"
}

unzip() {
  echo "MOCK UNZIP: $*" >> "$MOCK_DIR/unzip.log"
  mkdir -p "$BIN_DIR"
  touch "$BIN_DIR/adb"
}

python3() {
  echo "MOCK PYTHON3: $*" >> "$MOCK_DIR/python3.log"
  mkdir -p "$BIN_DIR"
  touch "$BIN_DIR/adb"
}

chmod() {
  echo "MOCK CHMOD: $*" >> "$MOCK_DIR/chmod.log"
}

# Override command to mock `command -v unzip`
command() {
  if [[ "$1" == "-v" && "$2" == "unzip" ]]; then
    if [[ "$MOCK_MISSING_UNZIP" == "1" ]]; then
      return 1
    else
      return 0
    fi
  fi
  builtin command "$@"
}

@test "install_adb on darwin downloads darwin zip" {
  export OSTYPE="darwin20.0"
  run install_adb
  grep "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip" "$MOCK_DIR/curl.log"
}

@test "install_adb on linux downloads linux zip" {
  export OSTYPE="linux-gnu"
  run install_adb
  grep "https://dl.google.com/android/repository/platform-tools-latest-linux.zip" "$MOCK_DIR/curl.log"
}

@test "install_adb uses unzip when available" {
  export OSTYPE="linux-gnu"
  export MOCK_MISSING_UNZIP=0
  run install_adb
  grep "platform-tools.zip" "$MOCK_DIR/unzip.log"
  [ ! -f "$MOCK_DIR/python3.log" ]
}

@test "install_adb uses python3 fallback when unzip is missing" {
  export OSTYPE="linux-gnu"
  export MOCK_MISSING_UNZIP=1
  run install_adb
  grep "platform-tools.zip" "$MOCK_DIR/python3.log"
  [ ! -f "$MOCK_DIR/unzip.log" ]
}

@test "install_adb adds bin dir to profile files" {
  export OSTYPE="linux-gnu"
  run install_adb
  grep "$BIN_DIR" "$HOME/.bashrc"
}

@test "install_adb calls chmod if adb binary exists" {
  export OSTYPE="linux-gnu"
  run install_adb
  grep "+x $BIN_DIR/adb" "$MOCK_DIR/chmod.log"
}
