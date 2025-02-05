function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

%a1 = x
X = [ones(m,1) X]; % 5000 * 401
z2 = Theta1 * X' ; % 25 * 5000
a2 = sigmoid(z2); % 25 *5000
a2 = [ones(m,1) a2']; % 5000 * 26
z3 = Theta2 * a2'; % 10* 5000
a3 = sigmoid(z3); % 10 *5000

Y = zeros(num_labels, m);

for i = 1: m
    Y(y(i),i) = 1;
end

J = (-1/m) * sum(sum(Y .* log(a3)+(1-Y).*log(1-a3))); 

reg = (lambda/(2*m)) * (sum(sum(Theta1(:,2:end).^2))+sum(sum(Theta2(:,2:end).^2)));

J = J + reg;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%

for i = 1:m
    %step1
    a1_t = X(i,:); % 1*401
    a2_t = a2(i,:); % 25 *1
    z2_t = z2(:,i); %25*1
    a3_t = a3(:,i); %10*1
    z3_t = z3(:,i); % 10*1

    %step2
    delta3 = a3_t - Y(:,i); %10*1
    %step3
    delta2 = Theta2'*delta3 .* sigmoidGradient([1;z2_t]); %(26*10)*(10*1).* (26*1)
    %step4
    Theta2_grad = Theta2_grad + delta3*a2_t; % 10*26 + 10*1 * 1*26
    Theta1_grad = Theta1_grad + delta2(2:end)*a1_t; % 25*401 + 25*1 * (1*401)

end
%step5
   Theta2_grad = Theta2_grad / m;
   Theta1_grad = Theta1_grad / m;


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
Theta2_grad(:,2:end) =  Theta2_grad(:,2:end) + lambda * Theta2(:,2:end) / m;
Theta1_grad(:,2:end) =  Theta1_grad(:,2:end) + lambda * Theta1(:,2:end) / m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
