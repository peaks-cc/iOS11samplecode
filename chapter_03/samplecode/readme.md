## 概要

Pythonのコードは，すべてのJupyter Notebook向けに書いています．
このため，Pythonのコードを動作させるためにまず，Jupyter Notebookをインストールしてください．

## Core ML Tools インストール

`pip`でまずCore ML Toolsをインストールする．

```
pip install -U coremltools
```

# Jupyter Notebook(for Mac)

Linuxの場合は，そのまま，パッケージマネージャでインストールするとよいと思います．



### 日本語フォントのためにライブラリをインストールする

[https://gcc.gnu.org/wiki/GFortranBinaries](https://gcc.gnu.org/wiki/GFortranBinaries)から，gfortranをセットします．
次に，freetypeをbrewでインストールします．

```
brew install freetype
```

### Jupyter Notebookのインストール

```
pip install scikit-learn numpy scipy matplotlib cython jupyter
```


### 日本語フォント

Jupyter Notebookで日本語を表示するために，IPAフォントをセットアップします．
フォントは，[ここ](https://ja.osdn.net/projects/ipafonts/releases/47610)からダウンロードし，`~/Library/Fonts/`にコピーしてください．
これでJupyter Notebookで日本語がレンダリングできるはずです．うまくいかないときは，`~/.matplotlib/fontList.cache`を削除して，Jupyter Notebookをリロードするとよいです．

