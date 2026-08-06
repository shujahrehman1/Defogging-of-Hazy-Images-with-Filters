function Y=gamma_correction(X, in_interval, out_interval, gamma);
%% default return value
Y=[];
%% Parameter check
if nargin~=4
   disp('Error: The function takes exactly four arguments.');
   return;
end
%% Init. operations
X=double(X);
[a,b]=size(X);
%% Map to input interval
if ~isempty(in_interval)
    if length(in_interval)==2
        X=adjust_range(X,in_interval);
    else
       disp('Error: Input interval needs to be a two-component vector.');
       return;
    end
end
%% Do gamma correction
X=X.^gamma;    
%% Map to output interval
if ~isempty(out_interval)
    if length(out_interval)==2
        Y=adjust_range(X,out_interval);
    else
       disp('Error: Output interval needs to be a two-component vector.');
       return;
    end
end

end
