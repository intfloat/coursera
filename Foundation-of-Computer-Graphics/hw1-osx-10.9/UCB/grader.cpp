/*
 * grader.cpp
 *
 * Created on: Jan 16, 2012
 *     Author: bmwang, nestorga
 */

#include "grader.h"
#include <unistd.h>

Grader::Grader() {
  testsRun = false;
}

void Grader::init(string pre) {
  prefix = pre;
}

void Grader::loadCommands(string fname) {
  ifstream inpfile(fname.c_str());
  if(!inpfile.is_open()) {
    cout << "Unable to open file" << endl;
  } else {
    string line;
    map<string, vector<Command> > aliases;
    Command saveCmd(CMDT_SPECIAL, CMDINP_SAVE);

    while(inpfile.good()) {
      vector<string> splitline;
      string buf;

      getline(inpfile,line);
      stringstream ss(line);

      while (ss >> buf) {
        splitline.push_back(buf);
      }

      /* Valid commands:
       * alias
       * input
       * save
       * inputsave
       */

      //Ignore blank lines
      if(splitline.size() == 0) {
        continue;
      }

      //Ignore comments
      if(splitline[0][0] == '#') {
        continue;
      }

      //Alias
      else if(!splitline[0].compare("alias")) {
        vector<Command> aliasCommands;
        for(int i=2; i<splitline.size(); ++i) {
          Command curCommand(splitline[i]);
          aliasCommands.push_back(curCommand);
        }
        aliases[splitline[1]] = aliasCommands;
      }

      //Input, inputsave
      else if(!splitline[0].compare("input") ||
          !splitline[0].compare("inputsave")) {
        for(int i=1; i<splitline.size(); ++i) {
          if(aliases.count(splitline[i])>0) {
            vector<Command> aliasResolution = aliases[splitline[i]];
            //Ehh probably should use insert(), but laaazy
            for(int j=0; j<aliasResolution.size(); ++j) {
              cmds.push_back(aliasResolution[j]);
            }
          } else {
            Command curCommand(splitline[i]);
            cmds.push_back(curCommand);
          }
        }
        if(!splitline[0].compare("inputsave")) {
          cmds.push_back(saveCmd);
        }
      }

      //Save
      else if(!splitline[0].compare("save")) {
        cmds.push_back(saveCmd);
      }

    }
    inpfile.close();
  }
}

void Grader::runTests() {
  if(!testsRun) {
    testsRun = true;
    tests();
    //exit(0);
  }
}

void Grader::tests() {
  int imageNum = 0;
  stringstream fname;
  for(vector<Command>::iterator it = cmds.begin(); it != cmds.end(); ++it) {
    switch(it->type()) {
      case CMDT_SPECIAL:
        switch(it->input()) {
          case CMDINP_SAVE:
	    displayFunc();
	    usleep(250000);
            //imgSaver->saveFrame();
            fname.str("");
            fname << prefix << ".";
            fname << setfill('0') << setw(3) << imageNum;
            fname << ".png";
            imageNum++;
            screenshotFunc(fname.str());
	    usleep(250000);
	    break;
          default:
            cerr << "Invalid special command input " << it->input() << endl;
            break;
        }
        break;
      case CMDT_KEYBOARD:
        //Support mouse pos later
        keyboardFunc(it->input(),0,0);
	usleep(100000);
        break;
      case CMDT_KEYBOARD_SPECIAL:
        specialFunc(it->input(),0,0);
	usleep(100000);
        break;
      default:
        cerr << "Invalid command type: " << it->type() << endl;
        break;
    }
  }
}

void Grader::bindDisplayFunc(void (*func)(void)) {
  displayFunc = func;
}

void Grader::bindSpecialFunc(void (*func)(int key, int x, int y)) {
  specialFunc = func;
}

void Grader::bindKeyboardFunc(void (*func)(unsigned char key, int x, int y)) {
  keyboardFunc = func;
}

void Grader::bindScreenshotFunc(void (*func)(string fname)) {
  screenshotFunc = func;
}

Command::Command(string rawinput) {
  char firstChar = rawinput[0];
  //Single Quote: Special, Double Quote: Numerical Normal Keyboard
  if(firstChar == '\'' || firstChar == '\"') {
    //ugh maybe shouldnt use atoi, but whatever
    input_ = atoi(rawinput.substr(1,rawinput.size()-2).c_str());
    if(firstChar == '\'') {
      type_ = CMDT_KEYBOARD_SPECIAL;
    } else {
      type_ = CMDT_KEYBOARD;
    }
  }
  //Literal
  else if(rawinput.size()==1) {
    input_ = (int) firstChar;
    type_ = CMDT_KEYBOARD;
  }

  //...Else error.
  else {
    input_ = -1;
    type_ = -1;
    cerr << "Invalid Command: " << rawinput << endl;
  }
}
