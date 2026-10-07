% Fit capacity waveforms for selected towers relative to T0.
toolkitDir = fileparts(mfilename('fullpath'));
addpath(toolkitDir);

towers = [6, 13];
dataDir = fullfile(toolkitDir, '..', '2602CHINAPCB_Capac');
datasetLabel = 'PCBCHINA';
outputLabel = 'PCBCHINA';       % Results: output/<outputLabel>/capacity/.
towerSubfolders = false;        % Set true for new Windows toolkit data.

referenceTauSeconds = [];
for tower = towers
    cfg = pcbtest.default_config(tower);
    if towerSubfolders
        cfg.dataDir = fullfile(dataDir, sprintf('T%d', tower));
        cfg.capacity.referenceDir = fullfile(dataDir, 'T0');
    else
        cfg.dataDir = dataDir;
        cfg.capacity.referenceDir = dataDir;
    end
    cfg.filePrefix = sprintf('T%d_Capacity_%s_', tower, datasetLabel);
    cfg.outputDir = fullfile(toolkitDir, 'output', outputLabel, ...
        'capacity', sprintf('T%d', tower));
    cfg.capacity.source = 'waveforms';
    cfg.capacity.referencePrefix = sprintf('T0_Capacity_%s_', datasetLabel);
    cfg.capacity.referenceTauSeconds = referenceTauSeconds;
    % The legacy line-length and coupling-component fit is enabled by default.
    result = pcbtest.analyze_capacity(cfg);
    referenceTauSeconds = result.referenceTauSeconds;
end
