;;; clementine.el --- Provide functions to interact with your
;;; Clementine music player from emacs

;;; Commentary:
;;; None so far

;;; Code:

;;; Useful library
(require 'dbus)

;;; Useful variables
(defgroup clementine nil
  "Clementine.el configuration variable"
  :group 'External)

(defcustom clementine-service
  "org.mpris.clementine"
  "Clementine d-bus service."
  :type 'string
  :group 'clementine
  )

(defconst clementine-TrackList-path
  "/TrackList"
  "Path to interact with the Tracklist.")

(defconst clementine-Player-path
  "/Player"
  "Path to interact with the Clementine player.")

(defconst clementine-interface
  "org.freedesktop.MediaPlayer"
  "Interface to interact through for Clementine.")


;;; Convenience methods
(defun clementine-get-current-song-metadata ()
  "Return the metadata associated with the current song playing."
  (dbus-call-method :session clementine-service clementine-Player-path
                    clementine-interface "GetMetadata"))

(defun clementine-get-song-metadata (song_id)
  "Return the metadata for the song with id SONG_ID."
  (dbus-call-method :session clementine-service clementine-TrackList-path
                    clementine-interface
                    "GetMetadata" :int32 song_id))


(defun clementine-get-property (property song_object)
  "Return the value of the property PROPERTY for the song metadata SONG_OBJECT."
  (caadr (assoc property song_object)))

(defun clementine-display-song-info (song_object)
  "Return a string at represent the song SONG_OBJECT.
TODO: Make the format configurable"
  (format "%s - %s"
          (clementine-get-property "artist" song_object)
          (clementine-get-property "title" song_object)))



;;; clementine.el ends here
