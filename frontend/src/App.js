import React, { useState, useEffect } from 'react';
import {
  Box,
  Container,
  Heading,
  Text,
  VStack,
  HStack,
  Image,
  Button,
  useToast,
  Flex,
  Spinner,
  SimpleGrid,
  Badge,
} from '@chakra-ui/react';
import { FaUpload, FaDownload, FaRedo } from 'react-icons/fa';
import axios from 'axios';
import ImageUploader from './components/ImageUploader';
import BackgroundSelector from './components/BackgroundSelector';

// Get API URL from environment variables or default to localhost
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

function App() {
  const [uploadedImage, setUploadedImage] = useState(null);
  const [selectedBackground, setSelectedBackground] = useState(null);
  const [backgrounds, setBackgrounds] = useState([]);
  const [resultImage, setResultImage] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  const toast = useToast();

  // Fetch available backgrounds on component mount
  useEffect(() => {
    const fetchBackgrounds = async () => {
      setIsLoading(true);
      try {
        const response = await axios.get(`${API_URL}/api/backgrounds`);
        setBackgrounds(response.data);
        if (response.data.length > 0) {
          setSelectedBackground(response.data[0].name);
        }
      } catch (error) {
        console.error('Error fetching backgrounds:', error);
        toast({
          title: 'Error',
          description: 'Failed to load background images',
          status: 'error',
          duration: 5000,
          isClosable: true,
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchBackgrounds();
  }, [toast]);

  const handleImageUpload = (imageFile) => {
    setUploadedImage(imageFile);
    setResultImage(null); // Reset result when new image is uploaded
  };

  const handleBackgroundSelect = (backgroundName) => {
    setSelectedBackground(backgroundName);
  };

  const handleProcessImage = async () => {
    if (!uploadedImage || !selectedBackground) {
      toast({
        title: 'Missing information',
        description: 'Please upload an image and select a background',
        status: 'warning',
        duration: 5000,
        isClosable: true,
      });
      return;
    }

    setIsProcessing(true);
    const formData = new FormData();
    formData.append('image', uploadedImage);
    formData.append('background', selectedBackground);

    try {
      const response = await axios.post(`${API_URL}/api/process`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      setResultImage(response.data.result);
      toast({
        title: 'Success',
        description: 'Your profile picture has been generated!',
        status: 'success',
        duration: 5000,
        isClosable: true,
      });
    } catch (error) {
      console.error('Error processing image:', error);
      toast({
        title: 'Error',
        description: 'Failed to process your image',
        status: 'error',
        duration: 5000,
        isClosable: true,
      });
    } finally {
      setIsProcessing(false);
    }
  };

  const handleDownload = () => {
    if (!resultImage) return;

    const link = document.createElement('a');
    link.href = resultImage;
    link.download = 'rcb-profile-picture.png';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleReset = () => {
    setUploadedImage(null);
    setResultImage(null);
  };

  return (
    <Container maxW="container.xl" py={8}>
      <VStack spacing={8} align="stretch">
        <Box textAlign="center" py={4}>
          <Heading as="h1" size="2xl" color="rcb.red" mb={2}>
            RCB Profile Picture Generator
          </Heading>
          <Text fontSize="lg" color="gray.600">
            Upload your photo and get a custom RCB-themed profile picture
          </Text>
        </Box>

        {isLoading ? (
          <Flex justify="center" align="center" h="300px">
            <Spinner size="xl" color="rcb.red" />
          </Flex>
        ) : (
          <SimpleGrid columns={{ base: 1, md: 2 }} spacing={8}>
            <VStack spacing={6} align="stretch">
              <Box
                bg="white"
                p={6}
                borderRadius="lg"
                boxShadow="md"
                height="100%"
              >
                <Heading as="h2" size="md" mb={4}>
                  Upload Your Photo
                </Heading>
                <ImageUploader onImageUpload={handleImageUpload} />
                {uploadedImage && (
                  <Box mt={4} textAlign="center">
                    <Badge colorScheme="green" mb={2}>
                      Image uploaded
                    </Badge>
                    <Image
                      src={URL.createObjectURL(uploadedImage)}
                      alt="Uploaded"
                      maxH="200px"
                      mx="auto"
                      borderRadius="md"
                    />
                  </Box>
                )}
              </Box>
            </VStack>

            <VStack spacing={6} align="stretch">
              <Box
                bg="white"
                p={6}
                borderRadius="lg"
                boxShadow="md"
                height="100%"
              >
                <Heading as="h2" size="md" mb={4}>
                  Choose Background
                </Heading>
                <BackgroundSelector
                  backgrounds={backgrounds}
                  selectedBackground={selectedBackground}
                  onSelect={handleBackgroundSelect}
                />
              </Box>
            </VStack>
          </SimpleGrid>
        )}

        <Box textAlign="center" py={4}>
          <Button
            leftIcon={<FaUpload />}
            colorScheme="red"
            size="lg"
            onClick={handleProcessImage}
            isLoading={isProcessing}
            loadingText="Processing..."
            isDisabled={!uploadedImage || !selectedBackground}
            bg="rcb.red"
          >
            Generate Profile Picture
          </Button>
        </Box>

        {resultImage && (
          <Box
            bg="white"
            p={6}
            borderRadius="lg"
            boxShadow="md"
            textAlign="center"
          >
            <Heading as="h2" size="md" mb={4}>
              Your RCB Profile Picture
            </Heading>
            <Image
              src={resultImage}
              alt="Result"
              maxH="400px"
              mx="auto"
              borderRadius="md"
              mb={4}
            />
            <HStack spacing={4} justify="center">
              <Button
                leftIcon={<FaDownload />}
                colorScheme="green"
                onClick={handleDownload}
              >
                Download
              </Button>
              <Button
                leftIcon={<FaRedo />}
                colorScheme="gray"
                onClick={handleReset}
              >
                Start Over
              </Button>
            </HStack>
          </Box>
        )}

        <Box textAlign="center" pt={8} opacity={0.8}>
          <Text fontSize="sm" color="gray.500">
            © {new Date().getFullYear()} RCB Profile Picture Generator
          </Text>
        </Box>
      </VStack>
    </Container>
  );
}

export default App; 