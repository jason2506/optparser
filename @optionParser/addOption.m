function this = addOption(this, name, flags, varargin)

% check option name
if ~ischar(name) || ~isvarname(name)
    error(['Invalid option name: ', name]);
elseif ~isempty(this.opts) && ismember(name, {this.opts.name})
    error(['Conflicting option name: ', name]);
end

% check flags
if ischar(flags)
    flags = {flags};
elseif ~iscell(flags)
    error('Flags must be a cell array of strings');
elseif isempty(flags)
    error('Require at least one flag');
end

if ~isempty(this.opts)
    m = ismember(flags, [this.opts.flags]);
    idx = find(m);
    if ~isempty(idx)
        error(['Conflicting option flag: ', flags{idx}]);
    end

    b = cellfun(@isValidFlag, flags);
    idx = find(~b);
    if ~isempty(idx)
        error(['Invalid flag: ', flags{idx}]);
    end
end

p = inputParser;
p.FunctionName = 'addOption';
p = p.addParamValue('handle',   @(v) v, @is_function_handle);
p = p.addParamValue('desc',     '',     @ischar);
p = p.addParamValue('required', false,  @islogical);
p = p.addParamValue('nargs',    '1',    @isValidNargs);
p = p.addParamValue('default',  []);
p = p.addParamValue('const',    []);
p = p.parse(varargin{:});

opt = p.Results;
opt.name = name;
opt.flags = flags;

this.opts(end + 1) = opt;

end