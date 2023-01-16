function release-all-assignments
  ls source/ | xargs -L1 nbgrader generate_assignment --force 2>/dev/null
end

function build-course
    docker build config/ -f config/workspace_dockerfile -t (basename (pwd))
    echo "Built" (basename (pwd))
end

function run-course
    docker run --rm -it -p 8888:8888 \
        --volume (pwd)/workspace_files/assignments:/home/jovyan/work \
        (basename (pwd)) $argv
end

function clear-output-all-assignments
    jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace source/**/*.ipynb
end
