﻿//EXPORT try3 := 'todo';
//EXPORT try2 := 'todo';

//EXPORT solution := 'todo';

//EXPORT check := 'todo';
IMPORT TextSearch.Inverted;
IMPORT TextSearch.Common;
IMPORT STD;
IMPORT TextSearch.Inverted.Layouts;//EXPORT farah := 'todo';
//EXPORT parsing := 'todo';
ds := DATASET([{'thee is anew A.B.C and V.R'}], {STRING100 line}); 
 
 
PATTERN expr2 :=PATTERN(U'[a-zA-Z][.][a-zA-Z]*[.][a-zA-Z]*[.]*[a-zA-Z]*');


PATTERN ws := PATTERN('[ \t\r\n]'); 
 



 
PATTERN Alpha     := PATTERN('[A-Za-z]'); 
 

 
PATTERN Word  := Alpha+;     
 

 
PATTERN Article   := ['the', 'A']; 
 

 
TOKEN JustAWord := expr2 PENALTY(1);
 
 
 
PATTERN notHen := VALIDATE(Word, MATCHTEXT != 'hen');
 
 
 
TOKEN NoHenWord := notHen PENALTY(1); 
 

 
RULE NounPhraseComp1   := JustAWord ;
 
RULE NounPhraseComp2   := NoHenWord | Article ws Word; 
//RULE Noun3 := NounPhraseComp1 , NounPhraseComp2;


ps1 := { 
 


out1 := MATCHTEXT(NounPhraseComp1) }; 
 
ps2 := { 
 
out2 := MATCHTEXT(NounPhraseComp2) }; 

//ps3 := { 
 


//out3 := MATCHTEXT(Noun3) }; 
 


p11 := PARSE(ds, line, NounPhraseComp1, ps1, BEST,MANY,NOCASE); 
 
p22 := PARSE(ds, line, NounPhraseComp2, ps2, BEST,MANY,NOCASE); 
//p33 := PARSE(ds, line, Noun3, ps3, BEST,MANY,NOCASE); 

output(p11);
output(p22);
//output(p33);











prefix := '~thor::jdh::';
inputName := prefix + 'corrected_lda_ap_txtt_xml';

Work1 := RECORD
  UNICODE doc_number{XPATH('/DOC/DOCNO')};
  UNICODE content{MAXLENGTH(32000000),XPATH('<>')};
  UNICODE text{MAXLENGTH(32000000),XPATH('/DOC/TEXT')};
  UNSIGNED8 file_pos{VIRTUAL(fileposition)};
	UNICODE init;
	
END;


Inverted.Layouts.DocumentIngest cvt(Work1 lr) := TRANSFORM
  SELF.identifier := TRIM(lr.doc_number, LEFT,RIGHT);
  SELF.seqKey := inputName + '-' + INTFORMAT(lr.file_pos,12,1);
  SELF.slugLine := lr.text[1..STD.Uni.Find(lr.text,'.',1)+1];
  SELF.content := lr.content;
	SELF.init:=lr.content;

END;


stem := prefix + 'corrected_lda_ap_txtt_xml';
instance := 'initial2';

ds0 := DATASET(inputName, Work1, XML('/DOC', NOROOT));
inDocs := PROJECT(ds0, cvt(LEFT));
OUTPUT(ENTH(inDocs, 20), NAMED('Sample_20'));//will print only 20 records 

info := Common.FileName_Info_Instance(stem, instance);

///////////////////////////////////
expr:=U'[a-zA-Z][.][a-zA-Z]*[.][a-zA-Z]*[.]*[a-zA-Z]*';


cont:= RECORD
 string term;
 //inDocs.init_w_pun;
//set of  string x;
END;;

 

Inverted.Layouts.DocumentIngest filter(Inverted.Layouts.DocumentIngest doc) := TRANSFORM
 
//SELF.init:=REGEXREPLACE( expr,doc.content,STD.Uni.FilterOut(doc.init, '.'));//+REGEXFINDSET(expr,doc.content);

SELF.init:=REGEXREPLACE( expr,doc.content,STD.Uni.FilterOut(doc.init, '.'));
 


 
SELF := doc;
END;
s:= PROJECT(inDocs, filter(LEFT));
//OUTPUT(ENTH(s, 20),,'~tests' ,NAMED('Sample_200'));//will print only 20 records 

//output(s);
//output(REGEXFINDSET(expr,inDocs[1].content));

////////////////////////////////////






output(inDocs[1].content,NAMED('Before_init'));
output(s[1].init,NAMED('After_init'));

enumDocs    := Inverted.EnumeratedDocs(info,  s);
p1 := Inverted.ParsedText(enumDocs);
rawPostings := Inverted.RawPostings(enumDocs);



//OUTPUT(inDocs,,'~ONLINE::Farah::OUT::Solution1',OVERWRITE);
//OUTPUT(p1,,'~ONLINE::Farah::OUT::Solution2',OVERWRITE);
//OUTPUT(rawPostings,,'~ONLINE::Farah::OUT::Solution3',OVERWRITE);

//OUTPUT(enumDocs,,'~ONLINE::Farah::OUT::Solution4',OVERWRITE);



//OUTPUT(ENTH(rawPostings[1]), NAMED('Posting'));//will print only 20 records 


output(rawPostings,NAMED('Posting'));
output(p1,NAMED('parsed'));









//OUTPUT(rawPostings,,'~ONLINE::Farah::OUT::Solution3',OVERWRITE);


/*
initialism:=REGEXFINDSET(expr,(string)inDocs[1].content);
output(initialism);
A :=STD.Str.FilterOut(initialism[1], '.');
output(A);
*/
/*
cont filters(Inverted.RawPostings doc) := TRANSFORM


 SELF.term:='';
SELF := doc;
END;
r:= PROJECT(inDocs, filters(LEFT));
output(r);

 */
 
 
 p111 := PARSE(inDocs, content, NounPhraseComp1, ps1, BEST,MANY,NOCASE); 
 output(p111);
 //pr := Inverted.ParsedText(p111);
//sss:=REGEXREPLACE( expr,p111[1],STD.Uni.FilterOut(doc.init, '.'));
//output(p111);
 p222 := PARSE(inDocs, content, NounPhraseComp2, ps2, BEST,MANY,NOCASE); 
 output(p222);
 
 
 
 