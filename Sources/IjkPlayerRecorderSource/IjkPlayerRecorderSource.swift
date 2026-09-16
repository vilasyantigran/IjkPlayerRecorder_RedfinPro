/// Marker target for SwiftPM source distribution of the RedfinPro IJKPlayer fork.
///
/// The real player is the native Xcode project at:
/// `ios/IJKMediaPlayer/IJKMediaPlayer.xcodeproj`.
///
/// After SwiftPM fetches this repository, build FFmpeg/IJK manually from the
/// repository checkout using the README instructions.
public enum IjkPlayerRecorderSource {
    public static let repository = "https://github.com/vilasyantigran/IjkPlayerRecorder_RedfinPro"
}
