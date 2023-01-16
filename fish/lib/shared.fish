# This file defines the names of some functions which will have
# platform-specific implementations, but support non-specific workflows, so they
# require a consistent, shared API.

# If this function does not yet exist, stub it out with an error message.
function interface
  set fn $argv[1]
  if ! functions -q $fn
    function $fn -V fn
      echo "The function $fn has not been implemented for $PLATFORM" >&2
      return 255
    end
  end
end

interface open
interface copy
interface update
interface upgrade
interface alert
