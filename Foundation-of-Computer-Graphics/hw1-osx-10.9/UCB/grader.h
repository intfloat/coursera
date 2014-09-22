/*
 * grader.h
 *
 * Created on: Jan 16, 2012
 *     Author: bmwang
 */

#ifndef UCBGRADER_H_
#define UCBGRADER_H_

#include <iostream>
#include <fstream>
#include <vector>
#include <map>

#include <GLUT/glut.h>
#include <cstdio>
#include <cstdlib>
#include <iomanip>
#include <sstream>
#include <string>

using namespace std;

class Command;
//Command Types
enum { CMDT_SPECIAL, CMDT_KEYBOARD, CMDT_KEYBOARD_SPECIAL};
//"Special" Command Input
enum { CMDINP_SAVE };


class Grader {
  public:
    Grader();
    void init(string pre);
    void loadCommands(string fname);
    void runTests();
    void tests();
    void bindDisplayFunc(void (*func)(void));
    void bindSpecialFunc(void (*func)(int key, int x, int y));
    void bindKeyboardFunc(void (*func)(unsigned char key, int x, int y));
    void bindScreenshotFunc(void (*func)(string fname));

  private:
    string prefix;
    GLubyte* buffer;
    int width;
    int height;
    vector<Command> cmds;
    bool testsRun;
    void (*displayFunc)(void);
    void (*specialFunc)(int key, int x, int y);
    void (*keyboardFunc)(unsigned char key, int x, int y);
    void (*screenshotFunc)(string fname);
};

struct Command {
  public:
    Command(int type, int input) { type_ = type; input_ = input; };
    Command(string rawinput);
    int type() { return type_; };
    int input() { return input_; };
  private:
    int type_;
    int input_;
};

#endif /* UCBGRADER_H_ */
