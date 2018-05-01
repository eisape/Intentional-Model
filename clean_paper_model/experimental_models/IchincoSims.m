% simulations for the Yu & Smith (2007) cross-situational word learning
% paper.

clear all

addpath([pwd '/../data']);
addpath([pwd '/../helper_functions']);
addpath([pwd '/../baseline_functions']);
addpath([pwd '/../wurwur_functions']);

% first get the corpus, using the 4x4 condition.

gold_standard.map = [1:48; 1:48];
gold_standard.num_mappings = 48;

%% score bayesian model
% gamma matters a lot
% kappa matters not at all

parameters.alpha = 7; % lexicon size prior parameter
parameters.gamma = 1; % probability that a word refers to an intended object.
parameters.kappa = .05; % penalty for a non-refering use of a word

world.words = 1:48;
world.objects = 1:48;
world.num_words = 48; 
world.num_objects = 48;
world.mis = reshape(cumsum(ones(1,48^2)),[48 48])./(48.^2);
world.words_freq = ones(1,48).*6;
world.words_key = cellfun(@(x) num2str(x), num2cell(1:48),'UniformOutput',0);
world.objects_key = world.words_key;

for c = 1:2
  corpus = IchincoCorpus(c);
  
  for g = 1:100
    parameters.gamma = g/100;
    lex = sampleLexicon(world,parameters);
    corpus = addCorpusIntentCache(corpus, parameters);

    MElex = lex;
    MElex.map = [1:48; 1:48];
    MElex.num_mappings = 48;

    wdlex = lex;
    wdlex.map = [1:48 1:8; 1:48 25:32];
    wdlex.num_mappings = 56;

    piclex = lex;
    piclex.map = [1:48 25:32; 1:48 1:8];
    piclex.num_mappings = 56;

    [MEscore(g,c) MEprior MElike] = scoreLexicon(MElex,corpus);
    [wdscore(g,c) wdprior wdlike] = scoreLexicon(wdlex,corpus);
    [picscore(g,c) picprior piclike] = scoreLexicon(piclex,corpus);
  end
end

%% plot simulation results
titles = {'{\bf 4 words condition}','{\bf 4 pictures condition}'};

figure(1)
clf

for c = 1:2
  subplot(1,2,c)
  cla
  set(gca,'FontSize',18)
  hold on

  xs = [1:100]/100;
  h(1) = plot(xs,MEscore(:,c),'k-','LineWidth',2);
  h(2) = plot(xs,wdscore(:,c),'k--','LineWidth',2);
  h(3) = plot(xs,picscore(:,c),'k:','LineWidth',3);

  title(titles{c});
  axis([0 1 -1800 -800])
  
      set(gca,'XTick',[0:20:100]/100)

  if c==1
    xlabel('\gamma value')
    ylabel('log posterior probability')

  elseif c==2
%     set(gca,'XTick',[],'YTick',[]);
    legend(h,{'Mutually exclusive lexicon','4 words lexicon (non-ME)','4 pictures lexicon (non-ME)'},'Location','Best')
  end
end

%%
clf;
set(gca,'FontSize',16)
bar([MEprior sum(MElike) MEscore(10); wdprior sum(wdlike) wdscore(10); picprior sum(piclike) picscore(10)]);
set(gca,'XTickLabel',{'Mutual Exclusivity','No ME (words)','No ME (pictures)'})


%% run the Yu model

num_iter = 20; % number of EM steps

% add a null to the list of objects in each situation
world.num_objects = world.num_objects + 1;
world.objects_key{end+1} = 'NULL';
null_obj = world.num_objects;

for i = 1:length(corpus)
  corpus(i).objects(end+1) = null_obj;
end

thetas{1} = ones(world.num_objects,world.num_words) ./ world.num_words;

fprintf('*** running EM ***\niter\tchange\n');
for i = 2:num_iter
  estimated_counts{i} = computeCounts(thetas{i-1},corpus);
  thetas{i} = computeAssociations(estimated_counts{i},corpus,world);
  fprintf('%d\t%2.2f\n',i-1,nansum(nansum(abs(thetas{i}-thetas{i-1}))));
end

% now evaluate the results

yu_model_thetas = thetas{end}(:,1:end-1)'; % remove nulls
[p,r,f,yu_lex] = consolidateMatrix(yu_model_thetas,gold_standard,world);
evalLexicon(yu_lex,gold_standard,world);


%% ASSOCIATIVE MODELS

for i = 1:1000
  try
    corpus = IchincoCorpus(1);
  catch
  end

  world.words_freq = ones(1,48).*6;
  world.words_freq(1:8) = world.words_freq(1:8) + 6;
  world.objects_freq = ones(1,48).*6;

  assocs = zeros(gold_standard.num_mappings);
  for i = 1:length(corpus)
    for j = 1:length(corpus(i).words)
      for k = 1:length(corpus(j).objects)
        assocs(corpus(i).words(j),corpus(i).objects(k)) = ... 
          assocs(corpus(i).words(j),corpus(i).objects(k)) + 1;
      end
    end
  end

  % the max F score is 1.

  [assoc_p,assoc_r,assoc_f,best_a] = consolidateMatrix(assocs,gold_standard,world);

  % do conditional probabilities, first p(object | word)

  p_object_given_word = assocs ./ repmat(sum(assocs,2),1,length(world.objects_key));
  [pogw_p,pogw_r,pogw_f,best_ogw] = consolidateMatrix(p_object_given_word,gold_standard,world);

  % now p(word | object)

  p_word_given_object = assocs ./ repmat(sum(assocs),length(world.words_key),1);
  [pwgo_p,pwgo_r,pwgo_f,best_wgo] = consolidateMatrix(p_word_given_object,gold_standard,world);

  % now do mutual information

  p_word = (world.words_freq ./ sum(world.words_freq))';
  p_object = world.objects_freq ./ sum(world.objects_freq);
  p_word_and_object = assocs ./ sum(sum(assocs));

  mi = p_word_and_object ./ (repmat(p_word,1,length(world.objects_key)) ...
    .* repmat(p_object,length(world.words_key),1));
  [mi_p,mi_r,mi_f,best_mi] = consolidateMatrix(mi,gold_standard,world);
  
  mi_right(i) = best_mi.map(1,1) == 1;
end

%%
figure(1)
clf
set(gcf,'renderer','zbuffer')
set(gca,'FontSize',18)
imagesc(mi)
colormap(gray)
xlabel('objects')
ylabel('words')

%% INFERENCE now run the bayesian model on this corpus
% converge
num_samps = 100000;

lex = sampleLexicon(world,parameters);
corpus = addCorpusIntentCache(corpus, parameters);

score = scoreLexicon(lex,corpus);

for t = 1:num_samps
  [new_lex search_move new_corpus move_num moves] = mutate(lex,corpus);
  new_score = scoreLexicon(new_lex,corpus);

  % use a greedy search to save time, works fine
  if new_score > score 
    lex = new_lex;
    score = new_score;       
  end

  % give updates
  disp([num2str(t) ': accept mutation -' search_move]);
  if rem(t,5000)==0, evalLexicon(lex,gold_standard,world); WaitSecs(2); drawnow; end;

end