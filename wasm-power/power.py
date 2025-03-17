# power.py
def power(base, exponent):
    """
    Calculate the power of base raised to exponent
    
    Args:
        base: The base number
        exponent: The exponent to raise the base to
        
    Returns:
        The result of base^exponent
    """
    return base ** exponent

# Export the function to make it available in JavaScript
__all__ = ['power']
