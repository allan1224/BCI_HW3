%% Task 1
clear;
init;
% First start with cartesian coordinates
set_type('X');
% Pick one fold as training set 
set_train(1);
% Pick a different fold as test set
set_test(2); 
% train 
train;
% visualize
newwindow(1,'train') 
newwindow(2,'test') 

% Commentary:
% Performance on train does a lot better than on test because
% the model has seen the train data before, as that was the data
% it learned from. The peerformance on test is worst and varies 
% much more because that is the data it has never seen before so
% naturally there is more variability

%% Task 2
set_type('torque');
%  Pick one fold as training set 
set_train(3);
% Pick a different fold as test set 
set_test(4); 
% Train. Record the resulting performance (both the test and training performance). 
train;
performance_train_f1 = parms.net.fvaf_train
performance_test_f1 = parms.net.fvaf_test

% Increase the number of folds used as training set to two 
set_train([3,5]);
% Test on the same fold as before
set_test(4);
% Train. Record the resulting performance 
train;
performance_train_f2 = parms.net.fvaf_train
performance_test_f2 = parms.net.fvaf_test

% Q: How does the training set performance change as we move from one to two training 
% folds? Why? 

% Q: How does the test set performance change as we move from one to two training folds? 
% Why? 
% Gets better -> exposed to more data

%%
% Continue by increasing by one the number of training set until the training set reach the 
% maximum number of folds available and record these results. 
clear;
init;
set_type('torque');
set_test(10);
for fold = 1:9 % max # folds available
    currentFolds = 1:fold
    set_train(currentFolds);
    train;
    fvaf_train_shoulder(fold) = parms.net.fvaf_train(1);
    fvaf_train_elbow(fold) = parms.net.fvaf_train(2);
    fvaf_test_shoulder(fold) = parms.net.fvaf_test(1);
    fvaf_test_elbow(fold) = parms.net.fvaf_test(2);
end

%%
% Report  in  one  single  figure  the  curves  for  all  the  predictions  (i.e.  train  shoulder,  test 
% shoulder, train elbow, test elbow). Use plot function in matlab (see Figure 1 as template). 
figure;
plot(fvaf_train_shoulder,'color','red');
hold on;
plot(fvaf_train_elbow,'--','color','red');
hold on;
plot(fvaf_test_shoulder,'color','blue');
hold on;
plot(fvaf_test_elbow,'--','color','blue');
xlabel("number of folds");
ylabel("FVAF");
title("Prediction performance");
legend('train shoulder','train elbow','test shoulder','test elbow');

% Q: Based on these results, which is the number of folds you would use for the train set? 
% Which considerations you make in performing such choice? 


%% Task 3
clear;
init;
%  Pick 2 folds as training set 
set_train([3,4]);
% Pick one fold as test set 
set_test(5); 

% Set predictor to cartesian coordinates
set_type('X');
% Train. Record the resulting performance (both the test and training performance). 
train;
fvaf_train_x = parms.net.fvaf_train(1);
fvaf_test_x = parms.net.fvaf_test(1);
fvaf_train_y = parms.net.fvaf_train(2);
fvaf_test_y = parms.net.fvaf_test(2);

% Set predictor to torquw 
set_type('torque');
% Train. Record the resulting performance (both the test and training performance). 
train;
fvaf_train_torque_shoulder = parms.net.fvaf_train(1);
fvaf_test_torque_shoulder = parms.net.fvaf_test(1);
fvaf_train_torque_elbow = parms.net.fvaf_train(2);
fvaf_test_torque_elbow = parms.net.fvaf_test(2);

% Set predictor to cartesian velocity
set_type('dX');
train;
fvaf_train_dx = parms.net.fvaf_train(1);
fvaf_test_dx = parms.net.fvaf_test(1);
fvaf_train_dy = parms.net.fvaf_train(2);
fvaf_test_dy = parms.net.fvaf_test(2);

% Set predictor to cartesian acceleration
set_type('ddX');
train;
fvaf_train_ddx = parms.net.fvaf_train(1);
fvaf_test_ddx = parms.net.fvaf_test(1);
fvaf_train_ddy = parms.net.fvaf_train(2);
fvaf_test_ddy = parms.net.fvaf_test(2);

%%

figure;
x = categorical({'train shoulder','train elbow','test shoulder','test elbow'});
x = reordercats(x,{'train shoulder','train elbow','test shoulder','test elbow'});
y = [fvaf_train_x,fvaf_train_torque_shoulder,fvaf_train_dx,fvaf_train_ddx;  
    fvaf_train_y,fvaf_train_torque_elbow,fvaf_train_dy,fvaf_train_ddy;
    fvaf_test_x,fvaf_test_torque_shoulder,fvaf_test_dx,fvaf_test_ddx;
    fvaf_test_y,fvaf_test_torque_elbow,fvaf_test_dy,fvaf_test_ddy];
bar(x,y);
xlabel("predictor type");
ylabel("FVAF");
title("Prediction Performance");
legend('cartesian','torque','velocity','acceleration');


%% Task 3.1 - Animate
clear;
init;
% Set predictor to theta
set_type('theta');
train;
animate('train');
%animate('test');

%% Task 4 - PCA
clear;
init;
%  Pick 2 folds as training set 
set_train([6,7]);
% Pick one fold as test set 
set_test(8); 
% Set predictor to torque
set_type('torque');

%%
N_dimensions = 960;

for n = 1:N_dimensions % dimensions of PCA
    set_pca(n);
    train;
    fvaf_train_shoulder(n) = parms.net.fvaf_train(1);
    fvaf_train_elbow(n) = parms.net.fvaf_train(2);
    fvaf_test_shoulder(n) = parms.net.fvaf_test(1);
    fvaf_test_elbow(n) = parms.net.fvaf_test(2);
end

%%
figure;
plot(fvaf_train_shoulder,'color','red');
hold on;
plot(fvaf_train_elbow,'--','color','red');
hold on;
plot(fvaf_test_shoulder,'color','blue');
hold on;
plot(fvaf_test_elbow,'--','color','blue');
xlabel("principal components");
ylabel("FVAF");
title("Prediction performance");
legend('train shoulder','train elbow','test shoulder','test elbow');

%% Task 6: Varying Neural Delays 
clear;
init;
% Select a prediction mode of torque 
set_type('torque');
% Set no PCA compression 
set_pca(0);
% Pick two folds as training set 
set_train([1,2]);
% Pick one fold as test set 
set_test(3);
% Vary the delay from 1 to 20 (with several others in between) and train.
Max_delay = 20;
for delay = 1:Max_delay % delays
    set_delays(1:delay) 
    train;
    fvaf_train_shoulder(delay) = parms.net.fvaf_train(1);
    fvaf_train_elbow(delay) = parms.net.fvaf_train(2);
    fvaf_test_shoulder(delay) = parms.net.fvaf_test(1);
    fvaf_test_elbow(delay) = parms.net.fvaf_test(2);
end

%% Plot FVAF as a function of the delay.  
figure;
plot(fvaf_train_shoulder,'color','red');
hold on;
plot(fvaf_train_elbow,'--','color','red');
hold on;
plot(fvaf_test_shoulder,'color','blue');
hold on;
plot(fvaf_test_elbow,'--','color','blue');
xlabel("delay");
ylabel("FVAF");
title("Prediction performance");
legend('train shoulder','train elbow','test shoulder','test elbow');


%% Bonus 
% use grid search on the hyperparameters
