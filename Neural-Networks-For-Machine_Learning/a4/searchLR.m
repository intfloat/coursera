% this function is used for find appropriate learning rate

function searchLR()
	n_hid = 300;
	lr_rbm = 0.02;
	lr_classification = 0.058;
	n_iterations = 1000;
	% iterate for 10 times, the one which has the smallest
	% cross-entropy error on validation data will be regarded
	% as the final answer
	for i = 1:10
		lr_classification = lr_classification * 1.5;
		fprintf("current value of learning rate is: %f\n\n", lr_classification);
	        a4_main(n_hid, lr_rbm, lr_classification, n_iterations);
		fflush(1);
	end
end

