// Hide container on page load
$('.container').fadeOut(0);

// Listen for messages from the game client
window.addEventListener('message', function(event) {
    const data = event.data;
    
    // Only process if we have data
    if (data) {
        // Show zone notification
        if (data.action === 'show') {
            // Clear any existing content
            $('.container').html('');
            
            // Create notification elements
            const notification = `
                <div class="zone-notification">
                    <div class="zone-prefix">${data.prefix || 'Safe Zone:'}</div>
                    <div class="zone-name">${data.zoneName || 'Unknown Area'}</div>
                    <div class="zone-message">${data.message || 'NO FIGHTING ALLOWED'}</div>
                </div>
            `;
            
            // Add to container and show with animation
            $('.container').html(notification);
            $('.container').fadeIn(300);
        }
        
        // Hide zone notification
        if (data.action === 'hide') {
            $('.container').fadeOut(300, function() {
                // Clear content after fade out
                $(this).html('');
            });
        }
    }
}); 