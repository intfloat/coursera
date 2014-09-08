object Settings {
  // when changing this, also look at 'scripts/gradingImpl' and the files in s3/settings
  // val courseId = "progfun-2012-001"
  def baseURL(courseId: String) = 
    courseId match {
      case "progfun-004" | "reactive-001" =>
        "https://class.coursera.org/" + courseId
      case "progfun-epfl-001" =>
        "https://epfl.coursera.org/" + courseId
    }

  def challengeUrl(courseId: String) = baseURL(courseId) + "/assignment/challenge"

  def submitUrl(courseId: String) = baseURL(courseId) + "/assignment/submit"

  // def forumUrl(courseId: String) = baseURL(courseId) "/forum/index"

  // def submitQueueUrl(courseId: String) = baseURL(courseId) +"/assignment/api/pending_submission"

  def uploadFeedbackUrl(courseId: String) = baseURL(courseId) + "/assignment/api/score"

  val maxSubmitFileSize = {
    val mb = 1024 * 1024
    10 * mb
  }

  val submissionDirName = "submission"

  val testResultsFileName = "scalaTestLog.txt"
  val policyFileName = "allowAllPolicy"
  val submissionJsonFileName = "submission.json"
  val submissionJarFileName = "submittedSrc.jar"

  // time in seconds that we give scalatest for running
  val scalaTestTimeout = 320
  val individualTestTimeout = 40

  // default weight of each test in a GradingSuite, in case no weight is given
  val scalaTestDefaultWeigth = 10

  // when students leave print statements in their code, they end up in the output of the
  // system process running ScalaTest (ScalaTestRunner.scala); we need some limits.
  val maxOutputLines = 10*1000
  val maxOutputLineLength = 1000

  val scalaTestReportFileProperty = "scalatest.reportFile"
  val scalaTestIndividualTestTimeoutProperty = "scalatest.individualTestTimeout"
  val scalaTestReadableFilesProperty = "scalatest.readableFiles"
  val scalaTestDefaultWeigthProperty = "scalatest.defaultWeight"

  // debugging / developping options

  // don't decode json and unpack the submission sources, don't upload feedback
  val offlineMode = false
}
