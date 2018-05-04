% make a plot of the current lexicon and its performance relative to the
% gold standard.  red entries are correct. 

function evalLexicon(lexs,good_lex,world)

lex = lexs(1);

clf
axis([1 2.5 0 lex.num_mappings+1])
axis off;

[w,in] = sort(lex.map(1,:),2);
m = lex.map(2,in);

% column headers
text(1,lex.num_mappings + 2,'WORD','FontSize',14,'FontWeight','Bold');
text(1.5,lex.num_mappings + 2,'ASSOC FREQ','FontSize',14,'FontWeight','Bold');
text(2,lex.num_mappings + 2,'OBJECT','FontSize',14,'FontWeight','Bold');

% print each entry from the lexicon
for i = 1:lex.num_mappings
  if isempty(intersect(find(good_lex.map(1,:)==w(i)),find(good_lex.map(2,:)==m(i))))
    text(1,i,world.words_key{w(i)});
    text(1.5,i,num2str(world.words_freq(w(i))));
    text(2,i,world.objects_key{m(i)});
  else
    text(1,i,world.words_key{w(i)},'Color','Red');
    text(1.5,i,num2str(world.words_freq(w(i))));
    text(2,i,world.objects_key{m(i)},'Color','Red');
  end     
end

axis([1 2.25 0 lex.num_mappings + 3])

[p,r,f] = computeLexiconF(lex,good_lex);

title(['precision: ' num2str(p,'%.2f') ', recall: ' num2str(r,'%.2f') ...
  ', F-score: ' num2str(f,'%.2f')],'FontSize',16,'FontWeight','Bold')

drawnow;