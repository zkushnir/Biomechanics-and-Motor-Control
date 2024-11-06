function [sys,x0]=ipm_animation2(t,x,u, flag, ts); 

% IPM Animation					 		                                          % 





% ---------------- %
% DECLARATION PART %
% ---------------- %


% global variables
global  hRLEG hLLEG hCOM % IPM Leg and Center of Mass
        
         



% ------------ %
% PROGRAM PART %
% ------------ %

% see Matlab S-Function Manual for the structuring of S-functions.

switch flag,
  

  
  % --------------
  % Initialization
  % --------------

  case 0,
     
    % create animation figure
    figure(1)
    clf
    axes
    axis image
    hold on
   
    
    % set axis range in meters
    axis([-1 10 -0.1 1.2])
    
    
    % initialize plot handles
    hRLEG  = plot( [0 0], [0 0], 'Color', [0 0 0.7], 'LineWidth', 2);
    hLLEG  = plot( [0 0], [0 0], 'Color', [0.7 0 0], 'LineWidth', 2);
    hCOM  = plot( 0,0, '.', 'MarkerSize', 50, 'Color', [0 0 0]);
    
    
    % Simulink interaction
    % --------------------
    
    % set io-data: .  .  .  number of Simulink u(i)-inputs  .  .
    sys = [0 0 0 6 0 0];
    
    % return intial conditions
    x0 = [];

 



  % ------------
  % Modification
  % ------------

  case 2, 
        
    % update LEG xy-vector data
    set(hRLEG, 'XData', [u(1) u(3)], 'YData', [u(2) u(4)]);
     
     % update LEG xy-vector data
    set(hLLEG, 'XData', [u(1) u(5)], 'YData', [u(2) u(6)]);
     
    % update LEG xy-vector data
    set(hCOM, 'XData', u(1), 'YData', u(2) );
    
    % force plot
    drawnow

    %no simulink interaction
    sys = []; 






  % -------------------
  % Output to Simulink 
  % ------------------
  
  case 3,             
      
    sys = []; %no outputs

   
    


  % ----------------------
  % Time of Next Execution
  % ----------------------
  
  case 4,

    % time simulation time for animation plot
  	sys = t + ts;




  % ----
  % Exit
  % ----
  
  case 9,
     
    sys=[]; %no interaction


end %switch
