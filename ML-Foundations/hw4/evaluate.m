function acc = evaluate(w, X, Y)
% to calculate accuracy on test set using weight vector w

yPred = X*w;
for i=1:size(yPred, 1)
    if yPred(i)<0
        yPred(i) = -1;
    else
        yPred(i) = 1;
    end
end
result = (yPred==Y);
acc = sum(result)/size(result, 1);

end
