P =[cimp('1.jpg') cimp(''2.jpg') cimp('3.jpg')];
T = [eye(79) eye(79) eye(79)]
net = newff(P,T,200,{tansig tansig}, 'trainingdx');
net.performFcn = 'mse';
net.trainParam.epochs = 5000;
net = train(net,P,T);

