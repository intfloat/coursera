// Transform.cpp: implementation of the Transform class.


#include "Transform.h"

//Please implement the following functions:
using glm::dot;
using glm::cross;

// Helper rotation function.  
mat3 Transform::rotate(const float degrees, const vec3& axis) {
  // YOUR CODE FOR HW1 HERE
  // M = I + (sin(theta) * K) + (1 - cos(theta)) * K^2
  mat3 K = mat3(0, axis[2], -axis[1], -axis[2], 0, axis[0], axis[1], -axis[0], 0);
  mat3 eye = mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);
  float radian = (degrees / 180.0) * pi;
  mat3 M = eye + sin(radian) * K + (1 - cos(radian)) * (K * K);
  // You will change this return call
  return M;
}

// Transforms the camera left around the "crystal ball" interface
void Transform::left(float degrees, vec3& eye, vec3& up) {
  // YOUR CODE FOR HW1 HERE
  // float theta = (degrees / 180.0) * pi;
  eye = rotate(degrees, glm::normalize(up)) * eye;
  return;
}

// Transforms the camera up around the "crystal ball" interface
void Transform::up(float degrees, vec3& eye, vec3& up) {
  // YOUR CODE FOR HW1 HERE
  vec3 another = cross(eye, up);
  eye = rotate(degrees, glm::normalize(another)) * eye;
  // up = cross(another, eye);
  return;
}

// Your implementation of the glm::lookAt matrix
mat4 Transform::lookAt(vec3 eye, vec3 up) {
  // YOUR CODE FOR HW1 HERE
  // eye = glm::normalize(eye);
  // up = glm::normalize(up);
  vec3 another = glm::normalize(glm::cross(eye, up));
  mat4 first = mat4(eye[0], up[0], another[0], 0, eye[1], up[1], another[1], 0, eye[2], up[2], another[2], 0, 0, 0, 0, 1);
  mat4 second = mat4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -eye[0], -eye[1], -eye[2], 1);
  mat4 res = first * second;
  // You will change this return call
  return res;
}

Transform::Transform()
{

}

Transform::~Transform()
{

}
