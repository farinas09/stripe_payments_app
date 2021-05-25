part of 'helpers.dart';

showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Platform.isAndroid
          ? AlertDialog(
              title: Text('Please Wait...'),
              content: LinearProgressIndicator(),
            )
          : CupertinoAlertDialog(
              title: Text('Please Wait'),
              content: CupertinoActivityIndicator(),
            );
    },
  );
}

showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Platform.isAndroid
          ? AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                MaterialButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            )
          : CupertinoAlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
    },
  );
}
