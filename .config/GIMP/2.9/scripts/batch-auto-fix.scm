  (define (batch-auto-fix pattern  
                radius  
                amount  
                threshold)  
  (let* ((filelist (cadr (file-glob pattern 1))))  
   (while (not (null? filelist))  
      (let* ((filename (car filelist))  
          (image (car (gimp-file-load RUN-NONINTERACTIVE  
                        filename filename)))  
          (drawable (car (gimp-image-get-active-layer image))))  
       (plug-in-unsharp-mask RUN-NONINTERACTIVE  
                  image drawable radius amount threshold)  
       (gimp-levels-stretch drawable)  
       (plug-in-color-enhance RUN-NONINTERACTIVE  
                  image drawable)  
       (gimp-file-save RUN-NONINTERACTIVE  
               image drawable filename filename)  
       (gimp-image-delete image))  
      (set! filelist (cdr filelist)))))
