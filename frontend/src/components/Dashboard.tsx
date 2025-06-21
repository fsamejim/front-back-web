import React from 'react';
import { Box, Typography, Button, Paper, Container } from '@mui/material';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router-dom';

export const Dashboard: React.FC = () => {
    const { user, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    return (
        <Container maxWidth="md" sx={{ mt: 4 }}>
            <Paper elevation={3} sx={{ p: 4 }}>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
                    <Typography variant="h4" component="h1">
                        Welcome to Dashboard
                    </Typography>
                    <Button 
                        variant="contained" 
                        color="secondary" 
                        onClick={handleLogout}
                        sx={{ minWidth: '100px' }}
                    >
                        Logout
                    </Button>
                </Box>
                
                <Typography variant="h6" color="text.secondary" gutterBottom>
                    Hello{user?.username ? `, ${user.username}` : ''}! You have successfully logged in.
                </Typography>
                
                <Typography variant="body1" sx={{ mt: 2 }}>
                    This is your dashboard where you can manage your account and access various features.
                </Typography>
            </Paper>
        </Container>
    );
};