import React, { useCallback } from 'react';
import { useDropzone } from 'react-dropzone';
import {
  Box,
  Text,
  VStack,
  Icon,
  useColorModeValue,
} from '@chakra-ui/react';
import { FaCloudUploadAlt } from 'react-icons/fa';

const ImageUploader = ({ onImageUpload }) => {
  const onDrop = useCallback(
    (acceptedFiles) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        onImageUpload(acceptedFiles[0]);
      }
    },
    [onImageUpload]
  );

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.jpeg', '.jpg', '.png', '.gif'],
    },
    maxFiles: 1,
    maxSize: 5242880, // 5MB
  });

  const borderColor = useColorModeValue('gray.300', 'gray.600');
  const activeBorderColor = 'rcb.red';
  const bgColor = useColorModeValue('gray.50', 'gray.700');
  const activeBgColor = useColorModeValue('gray.100', 'gray.600');

  return (
    <Box
      {...getRootProps()}
      borderWidth={2}
      borderRadius="md"
      borderStyle="dashed"
      borderColor={isDragActive ? activeBorderColor : borderColor}
      bg={isDragActive ? activeBgColor : bgColor}
      p={6}
      cursor="pointer"
      transition="all 0.2s"
      _hover={{
        borderColor: activeBorderColor,
        bg: activeBgColor,
      }}
    >
      <input {...getInputProps()} />
      <VStack spacing={2} align="center">
        <Icon as={FaCloudUploadAlt} w={12} h={12} color="rcb.red" />
        <Text fontWeight="medium" textAlign="center">
          {isDragActive
            ? 'Drop your image here'
            : 'Drag & drop your image here, or click to select'}
        </Text>
        <Text fontSize="sm" color="gray.500" textAlign="center">
          Supports JPG, PNG, GIF (max 5MB)
        </Text>
      </VStack>
    </Box>
  );
};

export default ImageUploader; 