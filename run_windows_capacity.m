% Acquire one capacity waveform per channel for T0 and selected towers.
toolkitDir = fileparts(mfilename('fullpath'));
addpath(toolkitDir);

% Edit these settings for this capacity measurement campaign.
towers = [0, 13];               % T0 is the reference; list it first.
dataRoot = 'C:\PCB_tests\capacity_run_001';
datasetLabel = 'PCBCERN';
matrixResource = '';            % Exact resource name from visadevlist.
scopeResource = '';             % Exact resource name from visadevlist.
matrixIdContains = '';          % Optional expected text from *IDN?.
scopeIdContains = '';           % Optional expected text from *IDN?.

if isempty(matrixResource) || isempty(scopeResource)
    error('pcbtest:Config', 'Set both VISA resource names before acquisition.');
end

for tower = towers
    cfg = pcbtest.default_config(tower);
    cfg.dataDir = fullfile(dataRoot, sprintf('T%d', tower));
    cfg.filePrefix = sprintf('T%d_Capacity_%s_', tower, datasetLabel);
    cfg.channels = 1:15;
    cfg.hardware.matrixResource = matrixResource;
    cfg.hardware.scopeResource = scopeResource;
    cfg.hardware.matrixIdContains = matrixIdContains;
    cfg.hardware.scopeIdContains = scopeIdContains;

    fprintf('\nCapacity, tower T%d: prepare the physical connection.\n', tower);
    reply = strtrim(input('Press Enter when ready, or type q to stop: ', 's'));
    if strcmpi(reply, 'q')
        fprintf('Stopped before tower T%d.\n', tower);
        return;
    elseif ~isempty(reply)
        error('pcbtest:OperatorInput', 'Press Enter or type q.');
    end

    pcbtest.acquire_capacity(cfg);
    fprintf('Completed capacity tower T%d. Data: %s\n', tower, cfg.dataDir);
end
