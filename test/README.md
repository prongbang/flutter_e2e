## Setup for Test

- macOS

```shell
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

sudo cd /usr/local && mkdir homebrew && cd homebrew

arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

/usr/local/homebrew/bin/brew install libsodium

cp /usr/local/homebrew/lib/libsodium.dylib /usr/local/lib/libsodium.dylib
```

- Windows

```shell
// assuming user installed libsodium as per the installation instructions
// see also https://py-ipv8.readthedocs.io/en/latest/preliminaries/install_libsodium/
return DynamicLibrary.open('C:\\Windows\\System32\\libsodium.dll');
```

- Linux

```shell
// assuming user installed libsodium as per the installation instructions
// see also https://libsodium.gitbook.io/doc/installation
return DynamicLibrary.open('/usr/local/lib/libsodium.so');
```

- Android

```shell
return DynamicLibrary.open('libsodium.so');
```

- iOS

```shell
return DynamicLibrary.process();
```
