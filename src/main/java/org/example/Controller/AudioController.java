package org.example.Controller;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;

@RestController
@RequestMapping("/api/audio")
public class AudioController {

    private final String uploadDirectory = "src/main/resources/uploads";

    @PostMapping("/upload")
    public ResponseEntity<String> uploadAudio(@RequestParam("file") MultipartFile file) {
        try {
            // 确保上传目录存在
            File dir = new File(uploadDirectory);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 保存文件
            String filePath = uploadDirectory + File.separator + file.getOriginalFilename();
            File destination = new File(filePath);
            file.transferTo(destination);

            // 返回文件访问路径
            String fileUrl = "http://localhost:8080/api/audio/files/" + file.getOriginalFilename();
            return ResponseEntity.ok(fileUrl);

        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("文件上传失败");
        }
    }

    @GetMapping("/files/{filename}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        try {
            File file = new File(uploadDirectory + File.separator + filename);
            Path path = Paths.get(file.getAbsolutePath());
            Resource resource = new UrlResource(path.toUri());

            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=\"" + filename + "\"")
                    .body(resource);
        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }
}
