close all
clear all

%% Specify label suffix for saving figures
suffix = '5_4_2020';

%% Set simulation parameters
params{1,1} = .05; %dt Time units in seconds
params{2,1} =0; %t0
tmax=50; % Basic period should be about 5 sec.
params{3,1}=tmax; %tmax Basic period should be about 5 sec.
t=params{2,1}:params{1,1}:params{3,1};
nt=length(t); % number of time points
xlimits=[10 40]; % time range to show in plotting

params{4,1} = 100; %pmax maximum pressure grasper can exert on food (an arbitrary numb.)
params{5,1}= 1.0/sqrt(2); %tau_p time constant (in seconds) for pressure applied by grasper - orginial is 1.0
params{6,1} = 2.0/sqrt(2); %tau_pinch time constant (in seconds) for pressure of pinch - original is 2.0
params{7,1} = 0.5/sqrt(2); %tau_pull time constant (in seconds) for B8 pulling
params{8,1} = 1.0/sqrt(2); %tau_m time constant (in seconds) for I2 and I3 muscles
params{9,1} = 1.0; %tau_x time constant (in seconds) for grapser motion - original 1.0
params{10,1} = 1.0; %tau_y time constant (in seconds) for body motion
params{11,1} = 0.01; %prot_pas passive protractive force - original 0.01
params{12,1} = 0.015; %retr_pas passive retractive force - original 0.015
params{13,1} = 1.0; %buccalM_K spring constant representing boddy from buccal mass to ground
params{14,1} = 0.0; %buccalM_rest resting position of body
params{15,1} = .15; %F_pinch pinch force, original 0.15params{18,1} = 1.0; %
params{16,1} = 1; % force scaler
params{17,1} = 0.1; %gap influence of CBI2-CBI3 gap junction on a scale of 0 to 1.  Not used yet...
params{18,1} = 190; %CBI3 refractory period duration
params{19,1} = 1; %Maximum I3 force
params{20,1} = 1; %Maximum I2 force
params{21,1} = 0.05; %Maximum hinge force


thresholds{1,1} = 0.75; %Prot_thresh threshold for having reached sufficient protraction - original 0.8
thresholds{2,1} = 0.4; %ret_thresh threshold for having reached sufficient retraction - original 0.4
thresholds{3,1} = 0.5; % threshold for activing B38 when B20 is silent (retraction/ingestion)
thresholds{4,1} = 0.4; % threshold for activing B38 when B20 is active (protraction/egestion)
thresholds{5,1} = 0.9; %B64_thresh_retract_biting
thresholds{6,1} = 0.5; %B64_thresh_retract_swallowing 
thresholds{7,1} = 0.55; %B64_thresh_retract_reject
thresholds{8,1} = 0.45; %B64_thresh_protract_biting
thresholds{9,1} = 0.45; %B64_thresh_protract_swallowing
thresholds{10,1} = 0.3; %B64_thresh_protract_reject
thresholds{11,1} = 0.2; %B4B5 threshold

seaweed_strength = 10;


% create stimulation pattern
stim=zeros(13,nt);

%% Biting
chemicalAtLips = ones(1,nt);
mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = zeros(1,nt);
[bite_avec,bite_bvec,bite_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

Plot_behavior_V009(t,bite_avec,bite_bvec,bite_cvec,['Bite_' suffix],xlimits)

%% Swallowing
chemicalAtLips = ones(1,nt);
mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = ones(1,nt);
[swallow_avec,swallow_bvec,swallow_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

Plot_behavior_V009(t,swallow_avec,swallow_bvec,swallow_cvec,['Swallow_' suffix],xlimits)

%% Rejection
chemicalAtLips = zeros(1,nt);
mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = ones(1,nt);
[reject_avec,reject_bvec,reject_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

Plot_behavior_V009(t,reject_avec,reject_bvec,reject_cvec,['Reject_' suffix],xlimits)

%% Multifunctional swallowing of different strength seaweeds
seaweed_strength_min = 0.1;
seaweed_strength_max = 0.5;
step_size = 0.1;
num_strengths = (seaweed_strength_max-seaweed_strength_min)/step_size+1;
i = 1;

figure
set(gcf,'Color','white')
for seaweed_strength = seaweed_strength_min:step_size:seaweed_strength_max
    chemicalAtLips = ones(1,nt);
    mechanicalAtLips = ones(1,nt);
    mechanicalInGrasper = ones(1,nt);
    [swallow_avec2,swallow_bvec2,swallow_cvec2] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);
    
    seaweed_strength_result{i,:} = {seaweed_strength,swallow_avec2,swallow_bvec2,swallow_cvec2};
    
    subplot(num_strengths,1,i)
    plot(t,swallow_bvec2(7,:),'k','LineWidth',2)
    hold on
    plot(t,(swallow_bvec2(6,:)-swallow_bvec2(8,:)),'b','LineWidth',2)
    hold off
    if i==1
        legend({'Normalized Force on Transducer','Normalized Grasper Motion'},'Orientation','horizontal','Position',[0.337905404191644,0.941469018401128,0.350331117341061,0.027292575735973],'Box','off','FontSize',12)
    end
    set(gca,'FontSize',16)
    grid on
    set(gca,'YGrid','off')
    %ylim([-2 2.1])
    xlim(xlimits)
    i=i+1;
end
xlabel('Time (s)')
saveas(gcf,['SeaweedStrength_' suffix '.png'])

%% Swallowing to rejection
t_switch = 19.95;
step_switch = t_switch/params{1,1};
chemicalAtLips = ones(1,nt);
chemicalAtLips(1,step_switch:nt) = zeros(1,length(step_switch:nt));

mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = ones(1,nt);
stim=zeros(13,nt);
seaweed_strength = 10;
[swallowToReject_avec,swallowToReject_bvec,swallowToReject_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

Plot_behavior_V009(t,swallowToReject_avec,swallowToReject_bvec,swallowToReject_cvec,['SwallowToReject_' suffix],xlimits)

%% Biting to swallowing
t_switch = 19.01;
step_switch = t_switch/params{1,1};

chemicalAtLips = ones(1,nt);
mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = zeros(1,nt);
mechanicalInGrasper(1,step_switch:nt) = ones(1,length(step_switch:nt));
stim=zeros(13,nt);
seaweed_strength = 10;
[biteToSwallow_avec,biteToSwallow_bvec,biteToSwallow_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

Plot_behavior_V009(t,biteToSwallow_avec,biteToSwallow_bvec,biteToSwallow_cvec,['BiteToSwallow_' suffix],xlimits)

%% B4/B5 Stimulation
% create stimulation pattern
stim=zeros(13,nt);
t_transitionidx_1 = 250; % start stimulating B4/B5
t_transitionidx_2 = 360; % start stimulating CBI2 in addition to B4/B5
t_transition_B4duration = 50;
stim(3,1:nt) = zeros(1,nt); % turn on extracellular stimulation of B4/B5
stim(3,t_transitionidx_1:(t_transitionidx_1+t_transition_B4duration)) = ones(1,length(stim(3,t_transitionidx_1:(t_transitionidx_1+t_transition_B4duration))));
stim(3,(t_transitionidx_1+t_transition_B4duration):end) = zeros(1,length(stim(3,(t_transitionidx_1+t_transition_B4duration):end)));

chemicalAtLips = ones(1,nt);
mechanicalAtLips = ones(1,nt);
mechanicalInGrasper = ones(1,nt);
seaweed_strength = 10;
[B4B5stim_avec,B4B5stim_bvec,B4B5stim_cvec] = Aplysia_boolean_model_V009(chemicalAtLips,mechanicalAtLips,mechanicalInGrasper,params,thresholds,stim,seaweed_strength);

xlimits = [2 t_transition_B4duration];
Plot_behavior_V009(t,B4B5stim_avec,B4B5stim_bvec,B4B5stim_cvec,['B4B5stim_' suffix],xlimits)


%% Plotting swallowing vs. rejection vs. biting

xl=[0 params{3,1}]; % show full time scale

%Grasper Motion
figure
set(gcf,'Color','white')
hold on
plot(t,(swallow_bvec(6,:)-swallow_bvec(8,:)),'c','LineWidth',2)
plot(t,(reject_bvec(6,:)-reject_bvec(8,:)),'b','LineWidth',2)
plot(t,(bite_bvec(6,:)-bite_bvec(8,:)),'m','LineWidth',2)
hold off
legend('Swallow', 'Reject','Bite')
title('Relative Grasper Motion')
set(gca,'FontSize',16)
ylabel('Normalized Position')
grid on
xlim(xl)

%Force
figure
set(gcf,'Color','white')
hold on
plot(t,swallow_bvec(7,:),'c','LineWidth',2)
plot(t,reject_bvec(7,:),'b','LineWidth',2)
plot(t,bite_bvec(7,:),'m','LineWidth',2)
hold off
legend('Swallow', 'Reject','Bite')
title('Force on Seaweed')
set(gca,'FontSize',16)
ylabel('Force')
grid on
xlim(xl)

%subplots

subplot(3,1,1)
plot(t,swallow_bvec(7,:),'b','LineWidth',2)
hold on
plot(t,(swallow_bvec(6,:)-swallow_bvec(8,:)),'m','LineWidth',2)
legend('Force','Grasper Motion')
set(gca,'FontSize',16)
grid on
%ylim([-2 2.1])
xlim(xl)

subplot(3,1,2)
plot(t,reject_bvec(7,:),'b','LineWidth',2)
hold on
plot(t,(reject_bvec(6,:)-reject_bvec(8,:)),'m','LineWidth',2)
legend('Force','Grasper Motion')
set(gca,'FontSize',16)
grid on
%ylim([-2 2.1])
xlim(xl)

subplot(3,1,3)
plot(t,bite_bvec(7,:),'b','LineWidth',2)
hold on
plot(t,(bite_bvec(6,:)-bite_bvec(8,:)),'m','LineWidth',2)
legend('Force','Grasper Motion')
set(gca,'FontSize',16)
grid on
%ylim([-2 2.1])
xlim(xl)