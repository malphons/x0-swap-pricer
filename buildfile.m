function plan = buildfile

import matlab.buildtool.tasks.*

% Create a plan from the task functions
plan = buildplan(localfunctions);

% Make the "test" task the default task in the plan
plan.DefaultTasks = "test";

% Setting up Dependancies
plan("check") = CodeIssuesTask();
plan("test") = TestTask(Dependencies="check");

end