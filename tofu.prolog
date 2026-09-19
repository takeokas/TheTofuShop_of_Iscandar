%;;;; -*-   coding: utf-8 -*-
%
% tofu.prolog  -  イスカンダルのトーフ屋ゲーム（Prolog版）
%   by たけおか (take at takeoka.net)
%   ver.1.0
%   2012/DEC/09
%  for SB-Prolog or GNU Prolog
%
% Copyright (C) 1978 - 2000 by Nobuhide Tsuda
% http://vivi.dyndns.org/tofu/tofu.html
% 著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。
%
% この Prolog版は、たけおか しょうぞうが、
% 永野圭一郎氏の(gano@is.s.u-tokyo.ac.jp) perl版 tofu.plを元に
% 書き直したものです。
%
%
% consult('/home/take/src/tofuya/tofu-prolog/tofu.prolog').
% ?- tofu.

% millisleep
%#+sbcl (defun millisleep(x) (sleep (/ x 1000)))
millisleep(X) :- XX is X/1000.0, sleep(XX).


% 乱数初期化
:- dynamic(irandom/2).
defRand :- retractall(irandom(_,_)),defRand1.
defRand :- defRand1.

defRand1 :-
	current_prolog_flag(prolog_name,'GNU Prolog'),
	%%for GnuProlog
	!,asserta((irandom(R,N) :- !,random(RR),R is floor(RR * N + 0.0))).
defRand1 :-
	%%for SWIProlog
	!,asserta((irandom(R,N) :- (!,R is random(N)))).

% 0 - 100の整数乱数
random100(R) :- irandom(R, 101).



%% TheMatrix風ゆっくり表示

%%%(defun disp(str)
%%(defun displn(x)
disp(S) :- write(S).


% コンピュータ側思考ルーティン
%    return min(int($comp / 40),
%	       ($hare >= 50 ? 500 : ($ame > 30 ? 100 : 300)));
%  (floor
%   (min (/ *comp*  40)
%	(if(>= *hare*  50)  500 
%	  (if(> *ame*  30) 100
%	    300)))))

calc(Comp, Hare, Ame, R) :- calc1(Hare,Ame,X), X1 is min(Comp / 40,X), R is floor(X1 + 0.0).
calc1(Hare, _, X) :- Hare >= 50, !, X is 500.
calc1(_, Ame, X) :- Ame >= 30, !, X is 100.
calc1(_,_, X) :- X is 300.


%%% ルールを表示
dispRule :- !,
 disp('ここはイスカンダル星。あなたはここでトーフ屋を経営し、'),nl,
 disp('地球への帰還費用を作り出さなくてはいけません。'),nl,
 disp('でもお向かいには、コンピュータが経営するトーフ屋があります。。。'),nl,nl,
 disp('トーフの原価は１個４０円、販売価格は５０円です。'),nl,
 disp('１日に売れる個数は天候に左右されます。'),nl,
 disp('晴れると５００個、くもりだと３００個、雨のときは１００個まで売れます。'),nl,
 disp('トーフは日持ちしないので、売れ残った分はすべて廃棄します。'),nl,
 disp('そこで、次の日の天気予報をよく見て、何個作るか決心してください。'),nl,
 disp('所持金５千円からはじめて早く３万円を超えた方が勝ちです。'),nl.



% 所持金を表示
%(defun dispShojikin(name gold)
%  (let ((ggg (floor(/ gold 1000))) )
%    (disp (format nil "   ~3a ~6d 円  " name gold))
%    (disp
%     (format nil "~a~a~%"
%	     (make-sequence 'string ggg :initial-element #\■)
%	     (make-sequence 'string (max (- 30 ggg)0) :initial-element #\□)))))

dispShojikin(Name, Gold):-
	!,disp(Name),disp('  '),
	GG is floor(Gold +0.0),
	disp(GG),disp('YEN '),nl,
	dispKakuBar(Name,Gold),nl.

dispKakuBar(Name,Gold):-
	disp(Name),
	G is floor(Gold / 1000.0),
	dispkaku1(G,'■'),
	dispkaku1(30 - G ,'□').


dispkaku1(N,_) :- N =< 0,!.
dispkaku1(N,Kaku):- !, disp(Kaku),N1 is N - 1,dispkaku1(N1,Kaku).

%%% 予報計算
%  (setq *hare* 
%	(- 100 (max *prob1* *prob2*)))
%  (setq *ame* (min *prob1* *prob2*))
%  (setq *kumori* (- 100 *hare* *ame*)))

yohou(Hare,  Kumori, Ame) :-
	random100(P1),
	random100(P2),
	Hare is 100 - max(P1,P2),
	Ame is min(P1,P2),
	Kumori is 100 - Hare - Ame.


% 予報表示
%(defun dispYohou(hare kumori ame)
%  (let* ((hhh (floor(/ (* hare 10) 25))) 
%	 (kkk (floor(/ (* kumori 10) 25)))
%	 (aaa (- (/ 1000 25) (+ hhh kkk))))
%    (disp
%     (format nil
%"~%明日の天気予報： 晴れ ~a%  くもり ~a%  雨 ~a%~%"
%        hare kumori ame))
%;(format t "hhh ~a ,kkk ~a,aaa ~a~%" hhh kkk aaa)


dispYohou(Hare, Kumori,Ame) :-
	nl,
	disp('明日の天気予報： 晴れ '),disp(Hare),disp('%'),
	disp('  くもり '),disp(Kumori),disp('%'),
	disp('  雨 '),disp(Ame),disp('%'),nl,
	HHH is floor((Hare * 10)/ 25.0),
	KKK is floor((Kumori * 10)/ 25.0),
	dispkaku1(HHH,'◎'),
	dispkaku1(KKK,'・'),
	dispkaku1((1000 / 25)- HHH -KKK,'●'),nl.
	
%;;;#| メイン部
tofu:-
	defRand,
	disp('イスカンダルのトーフ屋ゲーム (Prolog版)'),nl,
	disp('Copyright (c) 1978 - 2000 by Nobuhide Tsuda'),nl,
%    disp('Matrix モード(表示がゆっくり)にしますか？[y/n] '),
%    *slow-tty*	  (eql 'y (read)))
	disp('ルール説明しますか？[y/n] '),
	read(X),
	rule(X),
	!,tofux.


rule(X):- X == y,!, dispRule.
rule(_).


tofux:- !, tofu2(5000,5000),
	nl,disp('play again ? [y/n] '),
	read(X),
	!,X == y,
	tofux.


dispResult(Player, Comp) :-
	Player > Comp,!,nl,disp('あなたの勝ちです。').
dispResult(Player, Comp) :-
	Player == Comp,!,nl,disp('引き分けです。').
dispResult(_,_) :- !,nl,disp('コンピュータの勝ちです。').
   

inpTofu(Limit, X):-
	nl,disp('トーフを何個作りますか？（１〜'),
	disp(Limit),disp('）>'),
	read(X),
	X > 0, X =< Limit .

inpTofu(Limit, X):-
	!,inpTofu(Limit, X).

profit(N, Sold, Profit) :-
	Profit is min(Sold ,N) * 50 - (N * 40).



tofu2(Player,Comp) :-
	nl,disp('所持金：'),nl,
	dispShojikin('あなた',Player),
	dispShojikin('わたし',Comp),
	Player >= 30000,
	dispResult(Player, Comp),!.

tofu2(Player,Comp) :-
	Comp >=30000,
	dispResult(Player, Comp),!.

tofu2(Player,Comp) :-
	!,
%write(' tofu2 '),
	yohou(Hare,Kumori,Ame),
%write(' tofu2:Yoho '),
	dispYohou(Hare,Kumori,Ame),
	Limit is floor(Player / 40.0),
	inpTofu(Limit,PlayerMake),

	calc(Comp, Hare, Ame, CompMake),
	disp('わたしは '),disp(CompMake),disp('個 作ります。'),nl,
	millisleep(500),
	disp('＊＊＊＊＊ 次の日 ＊＊＊＊＊'),
	random100(R),
	tenki(R, Hare,Kumori,Ame, Tenki, Sold),

	nl,disp('今日の天気は'),
	dispDot,
	millisleep( 250),
	disp(Tenki),
	disp(' です。'),
	disp('       sold='),disp(Sold),

	millisleep(500),
	profit(PlayerMake,Sold, PlayerProfit),
	profit(CompMake,Sold, CompProfit),
	tofu2(floor(Player + PlayerProfit + 0.0),floor(Comp + CompProfit +0.0)).


tenki(R, _,_,Ame, ' 雨  (;_;) ', 100):-
	R =< Ame,!.
tenki(R, _,Kumori,Ame, ' くもり  (~_~) ', 300):-
	R =< (Ame + Kumori),!.
tenki(_,_,_,_, ' 晴れ ＼(^o^)／ ', 500).


dispDot:- dispkaku1(3,'.').

%%%
%=head1 NAME
%
%tofu.prolog - イスカンダルのトーフ屋ゲーム Prolog版
%
%=head1 SYNOPSIS
%
% 津田伸秀さん作「イスカンダルのトーフ屋ゲーム」のProlog版です。
% イスカンダル星でトーフ屋を経営するという日本初（１９７８年当時）の経営シミュレーションゲームです。トーフを売って地球に帰るための旅費を工面します。
% ISO標準のPrologで動作することを意図してコーディングしています。
%ただし、漢字文字の取扱いは、処理系に依存します。
%文字コードがUTF-8であれば、多くの処理系で取り扱えると思います。
%動作確認は SWI Prolog (http://www.swi-prolog.org/)で行いました。
%
%=head1 HOW TO PLAY
%
%実行するとルールを表示するかどうか聞いてきます。それを参照してください。
%
%
%=head1 COPYRIGHT
%
% Prologへの移植は、たけおか(take at takeoka.net)が行いました。
% 永野氏のperl版をもとに書き換えました。
% 著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。
%
% Perlへの移植は永野 (gano@is.s.u-tokyo.ac.jp) が行いました。ViViScript版のソースを参考にさせていただきました。著作権は津田伸秀さん (ntsuda@beam.ne.jp) にあります。
%
% イスカンダルのトーフ屋Prolog版はフリーソフトであり、オープンソースです。プログラムおよびソースは無償でコピー、配付することができます。ただし使用に際して不具合や事故が起こっても原作・著作権者、移植者はなんら保障を行ないません。あらかじめ御了承ください。
%
%=head1 SEE ALSO
%
%「イスカンダルのトーフ屋ゲーム」公式ページ
% http://vivi.dyndns.org/tofu/tofu.html
%
%
%%% EOF
