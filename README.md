# イスカンダルのトーフ屋 Prolog版

### 初出: 2012/DEC/09  
###  <a href="http://www.takeoka.org/~take">たけおか@AXE (竹岡尚三)</a>

<BR>
<BR>

## 「イスカンダルのトーフ屋」というのは…<br>

津田伸秀(ntsuda@master.email.ne.jp)という人が考案&開発したゲームで、  
1978年ごろ、月刊ASCII誌に載った。  
<br>
<a href="http://vivi.dyndns.org/tofu/tofu.html" target="_blank">
津田伸秀氏の「イスカンダルのトーフ屋ゲーム」ページ</a>
<br>
「主人公がイスカンダル星に1人取り残されて、トーフ屋さんを経営して地球までの帰還費用を稼ぐ」
という設定付きの、
シミュレーション・ゲームのはしりである。  
<br>
計算機と競って、早く目標額を得た方が勝ち。<br>
<br>
 天気がランダムに決まり、天候によってトーフの売れ行きが影響を受ける。  
天気予報が出るので、それをみて、どれだけトーフを仕込むか決める。  
<br>
 こういうシンプルなものだが、計算機と競う、とか、  
経済シミュレーション的なゲームが、皆無な時代だったので、かなり人気があった。  

## 僕は、計算機ではゲームはほとんどしないのだが…<br>
 大学に入ったら、先輩たちが暇つぶしに、  
この「イスカンダルのトーフ屋」をやっていた。  
 当然、このゲームは僕も知っていたが、一度もやらなかった。  
<br>
 最近、Webで「イスカンダルのトーフ屋」を発見し、すごくやりたくなった。  
UNIX(Linux,BSD)だと、Perl版がありがたい。  
<br>
でも、自分の好きなLispとPrologでやりたくなった。  
<br>
## というわけで、  
 トーフ屋さんのPerl版を元に、Prolog と Lisp へ、書き直してみた。  
<br>
遊んでみると、すごく楽しい。暇つぶしにちょうどいい。＼(^^)／<br>
<br><br>
## 謝辞
 オリジナルの考案&開発者の津田伸秀氏に感謝し、敬意を表したい。  
 Perl版を開発された永野圭一郎氏に感謝し、敬意を表したい。  
<br><br>

## Prolog 版
<a href="tofu.prolog" target="_blank">prolog版 「イスカンダルのトーフ屋ゲーム」(ソース,文字コードはUTF-8です)</a><br>
<br>
 このProlog版も完全なフリーソフトウェアです。  
<br>
動作確認は、  

* <a href="http://www.swi-prolog.org/" target="_blank">SWI-Prolog</a>
* <a href="http://www.gprolog.org/" target="_blank">Gnu-Prolog</a>

で行っている。  
<br>

### Prolog 版  遊び方  
SWI-Prologか Gnu-Prologを起動後  
<br>
```
?- consult('tofu.prolog').
% tofu.prolog compiled 0.00 sec, 20,736 bytes
true.

?- tofu.
```
としてください。<br>
<br>
※注意: 入力の末尾には、必ず「.」を付けてから、「enter」キーを押下してください。<br>
y や n の後にも必ず! つまり、「y.」や「n.」と入力する。<br>
数値は、「125.」などと入力。<br>
(Prologの入力とはそういうものです)<br>
<br>
<br>
<br>
## Common Lisp 版  
<a href="tofu.lisp" target="_blank">Common Lisp版 「イスカンダルのトーフ屋ゲーム」(ソース,文字コードはUTF-8です)</a><br>
<br>
 このCommon Lisp版も完全なフリーソフトウェアです。
  <br>
動作確認は、

* <a href="http://www.sbcl.org/" target="_blank">SBCL </a>

で行っている。<br>
<br>

### Common Lisp 版  遊び方  
SBCLを起動後<br>
```
* (load "tofu.lisp")

* (tofu)
```
としてください。
<br>
<br>
以上
