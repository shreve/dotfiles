set -gx MAMBA_ROOT_PREFIX "/opt/conda"
set -gx CONDA_PREFIX      "/opt/conda"

# Global conda setup
set -gx CONDA_EXE         "/opt/conda/bin/conda"
set -gx CONDA_PREFIX      "/opt/conda"
set _CONDA_ROOT           "/opt/conda"
set _CONDA_EXE            "/opt/conda/bin/conda"
set -gx CONDA_PYTHON_EXE  "/opt/conda/bin/python"

# Try to replace `conda activate base`
set -gx CONDA_DEFAULT_ENV "base"
set -x CONDA_SHLVL        "1"
set -x PATH               "/opt/conda/bin:$PATH"

function conda --inherit-variable CONDA_EXE
    if [ (count $argv) -lt 1 ]
        $CONDA_EXE
    else
        set -l cmd $argv[1]
        set -e argv[1]
        switch $cmd
            case activate deactivate
                eval ($CONDA_EXE shell.fish $cmd $argv)
            case install update upgrade remove uninstall
                $CONDA_EXE $cmd $argv
                and eval ($CONDA_EXE shell.fish reactivate)
            case '*'
                $CONDA_EXE $cmd $argv
        end
    end
end

function mamba --inherit-variable CONDA_EXE
	set -f MAMBA_EXE (dirname $CONDA_EXE)/mamba
  # echo $MAMBA_EXE

	switch $argv[1]
		case activate deactivate
			conda $argv
			return
	end

	$MAMBA_EXE $argv
end
