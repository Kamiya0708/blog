$(function() {
  //画像管理リスト
  var images = [];

  //エディタ設定
  $('#article_content').froalaEditor({
    language: 'ja',
    imageAllowedTypes: ["gif", "jpeg", "jpg", "png"],
    imageUploadURL: '/upload_image',
    //imageMaxSize: 5 * 1024 * 1024, //5MB
    imageUploadParams: {
      authenticity_token: $("#authenticity_token").val()
    },
    videoUpload: false
  })
  //エディタ内画像削除時
  .on('froalaEditor.image.removed', function(e, editor, $img) {
    //管理リストから削除
    images = images.filter((name) => name !== $img.attr('src').split('/').pop());
    $("#images_name").val(images);
    console.log(images);
  })
  //画像読み込み処理後
  .on('froalaEditor.image.loaded', function(e, editor, $img, response) {
    //読み込んだ画像を管理リストに追加
    images.push($img.attr('src').split('/').pop());
    $("#images_name").val(images);
    console.log(images);
  })
  //エラー発生時
  .on('froalaEditor.image.error', function (e, editor, error, response) {
    if (error.code == 1) alert('画像読み込みエラー');
    else if (error.code == 2) alert('アップロードURLエラー');
    else if (error.code == 3) alert('画像アップロードエラー');
    else if (error.code == 4) alert('解析結果エラー');
    else if (error.code == 5) alert('画像ファイルが大きすぎます。');
    else if (error.code == 6) alert('この拡張子はアップロードできません。');
  });

  //現在の画像ファイル名をリスト化
  $("img").each((index, $element) => images.push($element.src.split('/').pop()));
  $("#images_name").val(images);
});
