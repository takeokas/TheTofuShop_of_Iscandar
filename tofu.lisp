;;;; -*-   coding: utf-8 -*-
#|
 tofu.lisp  -  イスカンダルのトーフ屋ゲーム（Common Lisp版）
   by たけおか (take at takeoka.net)
   ver.1.0
 2012/DEC/08

 Copyright (C) 1978 - 2000 by Nobuhide Tsuda
 http://vivi.dyndns.org/tofu/tofu.html
 著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。

 この Common Lisp版は、たけおか しょうぞうが、
 永野圭一郎氏の(gano@is.s.u-tokyo.ac.jp) perl版 tofu.plを元に
書き直したものです。

 Perl版と同様の TheMatrixモード付き
   -- 文字がゆっくり出てきます。
   トーフの個数を聞かれているとき、「:tty」と入力すると、
   MatrixモードのON/OFFが切り替わります。
|#

;(load "tofu.lisp")
;(tofu)

#+sbcl (defun flush-terminal() (force-output))
#-sbcl (defun flush-terminal() ())

; millisleep
#+sbcl (defun millisleep(x) (sleep (/ x 1000)))
#-sbcl (defun millisleep(x) ())


(defvar *player*)
(defvar *comp*)

(defvar  *hare*)
(defvar  *kumori*)
(defvar  *ame*)

(defvar *slow-tty* t)

; 乱数初期化
(defvar *rand* (make-random-state t ))
; 0 - 100の整数乱数
(defun random100()
 (random 101 *rand*))


#| TheMatrix風ゆっくり表示
 disp(@) {
    if ($matrix) {
	foreach my $char (split(//, join("", @_))) {
	    print($char); millisleep(25);
	}
    }
    else { print(@_); }
}
 displn(@) { disp(@_, "\n"); }
|#

(defun disp(str)
  (cond
   ((not *slow-tty* )
    (format t "~a" str)
    (flush-terminal))
   (t
    (dotimes (i (length str))
      (format t "~a" (aref str i))
      (flush-terminal)
      (millisleep 25)))))

(defun displn(x)
  (disp x)
  (format t "~%"))


#| コンピュータ側思考ルーティン
 calc($$$$) {
    my($comp, $hare, $kumori, $ame) = @_;
    return min(int($comp / 40),
	       ($hare >= 50 ? 500 : ($ame > 30 ? 100 : 300)));
}
|#

(defun calc()
  (floor
   (min (/ *comp*  40)
	(if(>= *hare*  50)  500 
	  (if(> *ame*  30) 100
	    300)))))

;;; ルールを表示
(defun dispRule()
  (disp
"ここはイスカンダル星。あなたはここでトーフ屋を経営し、
地球への帰還費用を作り出さなくてはいけません。
でもお向かいには、コンピュータが経営するトーフ屋があります。。。

トーフの原価は１個４０円、販売価格は５０円です。
１日に売れる個数は天候に左右されます。
晴れると５００個、くもりだと３００個、雨のときは１００個まで売れます。
トーフは日持ちしないので、売れ残った分はすべて廃棄します。
そこで、次の日の天気予報をよく見て、何個作るか決心してください。
所持金５千円からはじめて早く３万円を超えた方が勝ちです。"
 ))


;;; 所持金を表示
(defun dispShojikin(name gold)
  (let ((ggg (floor(/ gold 1000))) )
    (disp (format nil "   ~3a ~6d 円  " name gold))
    (disp
     (format nil "~a~a~%"
	     (make-sequence 'string ggg :initial-element #\■)
	     (make-sequence 'string (max (- 30 ggg)0) :initial-element #\□)))))


;;; 予報計算
(defvar  *prob1*)
(defvar  *prob2*)

(defun yohou()
  (setq *prob1* (random100))
  (setq *prob2* (random100))
  (setq *hare* 
	(- 100 (max *prob1* *prob2*)))
  (setq *ame* (min *prob1* *prob2*))
  (setq *kumori* (- 100 *hare* *ame*)))

;;; 予報表示
(defun dispYohou(hare kumori ame)
  (let* ((hhh (floor(/ (* hare 10) 25))) 
	 (kkk (floor(/ (* kumori 10) 25)))
	 (aaa (- (/ 1000 25) (+ hhh kkk))))
    (disp
     (format nil
"~%明日の天気予報： 晴れ ~a%  くもり ~a%  雨 ~a%~%"
        hare kumori ame))
;(format t "hhh ~a ,kkk ~a,aaa ~a~%" hhh kkk aaa)

     (disp
      (format nil "~a~a~a~%"
	      (make-sequence 'string hhh :initial-element #\◎)
	      (make-sequence 'string kkk :initial-element #\・)
	      (make-sequence 'string aaa :initial-element #\●)))))


;;;#| メイン部
(defun tofu()
  (let (man)
    (disp
     (format nil "~a~%~a~%~%"
"イスカンダルのトーフ屋ゲーム (CL版)"
"Copyright (c) 1978 - 2000 by Nobuhide Tsuda"))

    (disp
     (format nil "~a"
	     "Matrix モード(表示がゆっくり)にしますか？[y/n] "))
    (setq *slow-tty*
	  (eql 'y (read)))

    (disp
     (format nil "~a"
	     "ルール説明しますか？[y/n] "))
    (if (eql 'y (read))
	(dispRule))
    (tofux)))

(defun tofux()
  (loop
   (tofu1)
   (cond
    ((> *player* *comp*)
     (disp (format nil "~%あなたの勝ちです。")))
    ((eql *player* *comp*)
     (disp (format nil "~%引き分けです。")))
    (t
       (disp (format nil "~%コンピュータの勝ちです。"))))

   (disp (format nil "~%play again ? [y/n] "))
   (if (not(eql 'y (read)))
       (return))))
   

(defun inpTofu (limit)
  (let (n)
    (loop
     (disp
      (format nil "~%トーフを何個作りますか？（１〜~a）>" limit))
     (setq n (read))
     (if(eql n :tty) ;;; if input is :tty then flip the tty mode.
	 (setq *slow-tty* (not *slow-tty*)))
     (if (and (numberp n) (> n 0) (<= n limit))
	  (return n)))))

(defmacro profit (n sold)
  `(- (*(min ,sold ,n) 50) (* ,n  40)))

(defun tofu1()
  (let (limit n)
    (setq *player* 5000)
    (setq *comp* 5000)

    (loop
	(disp (format nil "~%所持金：~%"))
	(dispShojikin "あなた"  *player*)
	(dispShojikin "わたし" *comp*)
	
	(if (or (>= *player* 30000)(>= *comp* 30000))
	    (return))

	(yohou)
	(dispYohou *hare* *kumori* *ame*)

	(setq limit (floor (/ *player* 40)))
	(setq human (inpTofu limit))

	(setq comp (calc))
	(disp
	 (format nil "わたしは ~a個 作ります。~%" comp))
	(millisleep 500)

	(disp "＊＊＊＊＊ 次の日 ＊＊＊＊＊")
	(setq r (random100))

	(cond
	 ((<= r *ame*)
	  (setq tenki " 雨  (;_;) ")
	  (setq sold 100))
	 ((<= r (+ *ame* *kumori*))
	  (setq tenki " くもり  (~_~) ")
	  (setq sold 300))
	 (t
	  (setq tenki " 晴れ ＼(^o^)／ ")
	  (setq sold 500)))
	  
	(disp (format nil "~%今日の天気は"))
	(dotimes (i 3)
	  (millisleep 250)
	  (disp "."))

	(millisleep 250)
	(disp
	 (format nil "~a です。" tenki))
(format t "sold=~a~%" sold)

	(incf *player* 
	      (profit human sold))

	(incf *comp* 
	      (profit comp sold))

	(millisleep 500) )))

#|

=head1 NAME

tofu.lisp - イスカンダルのトーフ屋ゲーム Common Lisp版

=head1 SYNOPSIS

津田伸秀さん作「イスカンダルのトーフ屋ゲーム」のCommon Lisp版です。
イスカンダル星でトーフ屋を経営するという日本初（１９７８年当時）の経営シミュレーションゲームです。トーフを売って地球に帰るための旅費を工面します。ANSI標準のCommon Lispで動作することを意図してコーディングしています。ただし、漢字文字の取扱いは、処理系に依存します。文字コードがUTF-8であれば、多くの処理系で取り扱えると思います。
動作確認は SBCL (http://www.sbcl.org/)で行いました。

=head1 HOW TO PLAY

実行するとルールを表示するかどうか聞いてきます。それを参照してください。

また、起動時に -matrix オプションを指定すると、TheMatrixモードで遊ぶことができます。ちょっとだけサイバーな感じです。是非お試し下さい。

=head1 COPYRIGHT

Common Lispへの移植は、たけおか(take at takeoka.net)が行いました。永野氏のperl版のもとに書き換えました。著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。

Perlへの移植は永野 (gano@is.s.u-tokyo.ac.jp) が行いました。ViViScript版のソースを参考にさせていただきました。著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。

イスカンダルのトーフ屋Common Lisp版はフリーソフトであり、オープンソースです。プログラムおよびソースは無償でコピー、配付することができます。ただし使用に際して不具合や事故が起こっても原作・著作権者、移植者はなんら保障を行ないません。あらかじめ御了承ください。

=head1 SEE ALSO

「イスカンダルのトーフ屋ゲーム」公式ページ
http://vivi.dyndns.org/tofu/tofu.html

映画 TheMatrix 日本語公式ページ
http://japan.whatisthematrix.com/


[EOF]
|#
