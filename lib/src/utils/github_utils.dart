import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<void> createGitHubIssueCommentWithImages({
  required String token,
  required String repo,
  required String reportId,
  required String branch,
  required Map<String, dynamic> reportJson,
  required String? userBodyImagePath,
  required Uint8List? userFaceImage,
  required Uint8List outfitImage,
  required String dressedAvatar,
}) async {
  var userBodyImageFile;
  var userBodyImageContent;

  if (userBodyImagePath != null && userFaceImage != null) {
    userBodyImageFile = File(userBodyImagePath);
    userBodyImageContent = userBodyImageFile.readAsBytesSync();
    // Upload user body image
    await uploadFileToGitHub(
      token: token,
      repo: repo,
      path: 'outfit-report-assets/$reportId/user_body_image.png',
      content: userBodyImageContent,
      message: 'Add user body image',
      branch: branch,
    );

    // Upload user face image
    await uploadFileToGitHub(
      token: token,
      repo: repo,
      path: 'outfit-report-assets/$reportId/user_face_image.png',
      content: userFaceImage,
      message: 'Add user face image',
      branch: branch,
    );

    await uploadFileToGitHub(
      token: token,
      repo: repo,
      path: 'outfit-report-assets/$reportId/outfit_image.png',
      content: outfitImage,
      message: 'Add outfit image',
      branch: branch,
    );
    reportJson['user_body_image_url'] =
        "https://github.com/revampedai/revamped/blob/main/outfit-report-assets/${reportId}/user_body_image.png";
    reportJson['user_face_image_url'] =
        "https://github.com/revampedai/revamped/blob/main/outfit-report-assets/${reportId}/user_face_image.png";
    reportJson['outfit_image_url'] =
        "https://github.com/revampedai/revamped/blob/main/outfit-report-assets/${reportId}/outfit_image.png";
  }

// Download dressed avatar image from URL
  final dressedAvatarResponse = await http.get(Uri.parse(dressedAvatar));
  if (dressedAvatarResponse.statusCode != 200) {
    print('Failed to download dressed avatar image.');
    return;
  }
  final dressedAvatarImageContent = dressedAvatarResponse.bodyBytes;

  // Upload dressed avatar image
  await uploadFileToGitHub(
    token: token,
    repo: repo,
    path: 'outfit-report-assets/$reportId/dressed_avatar_image.png',
    content: dressedAvatarImageContent,
    message: 'Add dressed avatar image',
    branch: branch,
  );

  // Add image URLs to the report JSON

  reportJson['dressed_avatar_image_url'] =
      "https://github.com/revampedai/revamped/blob/main/outfit-report-assets/${reportId}/dressed_avatar_image.png";
  ;

  // Create and prettify report JSON file
  final reportJsonContent =
      const JsonEncoder.withIndent('  ').convert(reportJson);
  final reportJsonPath = 'outfit-report-assets/$reportId/report.json';

  await uploadFileToGitHub(
    token: token,
    repo: repo,
    path: reportJsonPath,
    content: utf8.encode(reportJsonContent) as Uint8List,
    message: 'Add report JSON',
    branch: branch,
  );
}

Future<void> createGitHubIssueComment({
  required String token,
  required String repo,
  required String reportId,
  required String branch,
  required Map<String, dynamic> reportJson,
  required String? userBodyImagePath,
  required Uint8List? userFaceImage,
  required Uint8List outfitImage,
  required String dressedAvatar,
}) async {
  await createGitHubIssueCommentWithImages(
    token: token,
    repo: repo,
    reportId: reportId,
    branch: branch,
    reportJson: reportJson,
    userBodyImagePath: userBodyImagePath,
    userFaceImage: userFaceImage,
    outfitImage: outfitImage,
    dressedAvatar: dressedAvatar,
  );

  // Create issue comment
  final url = 'https://api.github.com/repos/$repo/issues/12/comments';

  // Construct the URL for the assets folder path
  final assetsUrl =
      'https://github.com/$repo/tree/$branch/outfit-report-assets/$reportId';

  final comment = """
**Report ID:** $reportId  
**Report date:** ${reportJson['report_date']}  
**Description:** ${reportJson['description']}  
**Occasion:** ${reportJson['occasion']}  
**Assets folder path:** [outfit-report-assets/$reportId]($assetsUrl)
""";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Authorization': 'token $token',
      'Accept': 'application/vnd.github.v3+json',
    },
    body: jsonEncode({
      'body': comment,
    }),
  );

  if (response.statusCode == 201) {
    print('Comment created successfully.');
  } else {
    print('Failed to create comment: ${response.statusCode}');
    print('Response: ${response.body}');
  }
}

Future<String?> uploadFileToGitHub({
  required String token,
  required String repo,
  required String path,
  required Uint8List content,
  required String message,
  required String branch,
}) async {
  final url = 'https://api.github.com/repos/$repo/contents/$path';

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Authorization': 'token $token',
      'Accept': 'application/vnd.github.v3+json',
    },
    body: jsonEncode({
      'message': message,
      'content': base64Encode(content),
      'branch': branch,
    }),
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['content']['download_url'];
  } else {
    print('Failed to upload file: ${response.statusCode}');
    print('Response: ${response.body}');
    return null;
  }
}
