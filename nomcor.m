function [out]=nomcor(tbl)

% Get measures of association for nominal variables
%
% Input: An m,n table of frequencies (f.i. generated by crosstab)
%
% Output: A structure with Chi2, p-value (Chi2), Cramer's V, Pearson's C,
% Adjusted Pearson C (scales to 1 on perfect association), Goodman-Kruskall
% Lambda (symmetric and asymmetric versions), Log Likelihood of the table.
%
%
% Examples...
%
% This will return Pearson C and Cramer V:
%
% x=randi(5,1,100); y=randi(5,1,100);
% table=crosstab(x,y);
% nominalstats = nomcor(table);
%
% This will return Cramer V:
%
% x=randi(3,1,100); y=randi(5,1,100);
% table=crosstab(x,y);
% nominalstats = nomcor(table);
%
% This will return Phi:
%
% x=randi(2,1,100); y=randi(2,1,100);
% table=crosstab(x,y);
% nominalstats = nomcor(table);
%
%
% Programmed by Fred Hasselman April 2012 
% Contact: me@fredhasselman.com

log0=10^-12;
alpha=.05;

[r,c]=size(tbl);
N=sum(sum(tbl));
n=0;
for ro=1:r
 for co=1:c
  n=n+1;
  O(n)=tbl(ro,co);
  E(n)=(sum(tbl(:,co))*sum(tbl(ro,:)))/N;
 end
end

% Write a warning when cell counts are low
if ~isempty(find(O<5, 1))
 out.WARNING=['WARNING: ',num2str(numel(find(O<5))),' cells detected with counts below 5'];
end

chi2=(abs(O-E)-.5).^2./E;
chi2(isnan(chi2))=0;
chi2(isinf(chi2))=0;
chi2=sum(chi2);
DF=(r-1)*(c-1);

% Determine which measure of association is appropriate
if r~=2||c~=2
 if r==c
  % Write info
  out.INFO=['Pearson C computed because #rows (',num2str(r),') == #columns (',num2str(r),') AND size of both > 2'];
  
  out.pearsonC=sqrt(chi2/(N+chi2));
  out.pearsonCadj=out.pearsonC/(sqrt((r-1)/r));
 else
  out.INFO=['Just Cramer V computed because #rows (',num2str(r),') ~= #columns (',num2str(r),') AND size of both > 2'];
 end
 q=min([r c]);
 out.cramerV=sqrt(chi2/(N*(q-1)));
else
 % To calculate directly from cell counts uncomment the line below
 %out.phi=((tbl(1,1)*tbl(2,2))-(tbl(1,2)*tbl(2,1)))/sqrt(sum(tbl(:,1))*sum(tbl(:,2))*sum(tbl(1,:))*sum(tbl(2,:)));
 out.INFO='Phi computed because the table size is 2x2';
 out.phi=sqrt(chi2/N);
 
 % Get Confusion matrix / ROC / PR measures
 out.TP=tbl(1,1);
 out.TN=tbl(2,2);
 out.FP=tbl(1,2);
 out.FN=tbl(2,1);
 
 out.ACC = (out.TP+out.TN)/N;      %Accuracy
 out.MSS = 1-out.ACC;              %Misclassification
 out.FPR = out.FP/(out.TN+out.FP); %Fall-out
 out.TPR = out.TP/(out.TP+out.FN); %Sensitivity, hit-rate, recall
 out.TNR = out.TN/(out.TN+out.FP); %Specificity, 1-FPR
 out.PPV = out.TP/(out.TP+out.FP); %Precision
 out.NPV = out.TN/(out.TN+out.FN); %Negative predictive value
 out.FDR = out.FP/(out.TP+out.FP); %False discovery rate
 out.MCC = (out.TP*out.TN-out.FP*out.FN)/sqrt((out.TP+out.FP)*(out.TN+out.FN)*(out.TP+out.FN)*(out.TN+out.FP));
 out.F1  = (2*out.TP)/(2*out.TP+out.FP+out.FN);
 out.joudenJ= out.TPR+out.TNR-1;
 
 
 out.LLpos =out.TPR/(1-out.TNR);
 out.LLneg =(1-out.TPR)/out.TNR;
 
 out.LLsim=log(out.ACC+log0);
 
 out.LLtable = 2*sum(O.*reallog((O./E)+log0));
 %out.LLtableP= chi2pdf(out.LLtable,DF);

 %Fisher
 out.F= abs((tbl(1,1)/tbl(1,1)+tbl(1,2))-(tbl(2,1)/tbl(2,1)+tbl(2,2)));
 
 %Degree of ostensible association
 out.Fass= abs((tbl(1,1)/(tbl(1,1)+tbl(1,2)))-(tbl(2,1)/(tbl(2,1)+tbl(2,2))));
 
 rsum=sum(tbl,2);
 csum=sum(tbl,1);
 
 prow=tbl(:,1)./rsum;
 % crow=tbl(:,2)./csum;
 Za=-realsqrt(2)*erfcinv(2-alpha);
 
 out.OR=prod(diag(tbl))/prod(diag(rot90(tbl)));
 out.yuleQ  = (out.OR-1)/(out.OR+1);
 out.LLOR=reallog(tbl(1,1)+log0)-reallog(tbl(1,2)+log0)-reallog(tbl(2,1)+log0)+reallog(tbl(2,2)+log0);
 out.ORse=realsqrt(sum(tbl(:).^-1)); %standard error of log(OR)
 out.ORci=exp(reallog(out.OR)+([-1 1].*(Za*out.ORse))); %OR confidence interval
 
 out.dOR= (out.TPR/(1-out.TPR))/((1-out.TNR)/out.TNR); %Diagnostic odds ratio
 out.eOR= (out.TPR/(1-out.TPR))/(out.TNR/(1-out.TNR)); %Error odds ratio
 
 
 out.rr=prow(1)/prow(2);
 out.rrse=realsqrt(abs(diff((1-prow))./tbl(:,1)))'; %standard error of log(RR)
 out.rrci=exp(reallog(out.rr)+([-1 1].*(Za*out.rrse))); %RR confidence interval
 out.absrrr=abs(diff(prow)); %absolute risk reduction
 out.relrrr=out.absrrr/prow(1); %relative risk reduction
 
 out.Hrows  = -((rsum(1)/N)*log2(rsum(1)/N) + (rsum(2)/N)*log2(rsum(2)/N));
 out.Hcols  = -((csum(1)/N)*log2(csum(1)/N) + (csum(2)/N)*log2(csum(2)/N));
 out.Htable = -((out.TP/N)*log2(out.TP/N) + (out.FP/N)*log2(out.FP/N) + (out.TN/N)*log2(out.TN/N) + (out.FN/N)*log2(out.FN/N));
 

end

 out.Chi2 =chi2;
 out.Chi2DF=DF;
 out.Chi2P=1-chi2cdf(chi2,DF);

out.gkLAMBDAasymROWS =(sum(max(tbl,[],1))-max(sum(tbl,2)))/(N-max(sum(tbl,2)));
out.gkLAMBDAasymCOLS =(sum(max(tbl,[],2))-max(sum(tbl,1)))/(N-max(sum(tbl,1)));
out.gkLAMBDAsymmetric=(sum(max(tbl,[],1))+sum(max(tbl,[],2))-max(sum(tbl,1))-max(sum(tbl,2)))/((N*2)-max(sum(tbl,1))-max(sum(tbl,2)));


% dO=diag(tbl);
% dE=[(sum(tbl(:,1))*sum(tbl(1,:)))/N; (sum(tbl(:,2))*sum(tbl(2,:)))/N];
% out.LLsame = 2*sum(dO.*log((dO./dE)+0.00001));
% out.LLsameP= chi2pdf(out.LLsame,DF);



end