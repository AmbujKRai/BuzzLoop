const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const eventController = require('../controllers/eventController');
const { protect } = require('../middleware/authMiddleware');
const { authorize } = require('../middleware/roleMiddleware');

const eventValidation = [
  body('title').trim().notEmpty().withMessage('Event title is required'),
  body('description').trim().notEmpty().withMessage('Event description is required'),
  body('location').trim().notEmpty().withMessage('Event location is required'),
  body('date').isISO8601().toDate().withMessage('Valid event date is required'),
  body('maxParticipants').optional().isInt({ min: 1 }).withMessage('Max participants must be a positive number'),
  body('category').isIn(['social', 'business', 'sports', 'education', 'other']).withMessage('Invalid category')
];

router.get('/', eventController.getAllEvents);
router.get('/:id', eventController.getEventById);

router.post('/',
  protect,
  authorize(['organizer', 'admin']),
  eventValidation,
  eventController.createEvent
);

router.put('/:id',
  protect,
  authorize(['organizer', 'admin']),
  eventValidation,
  eventController.updateEvent
);

router.delete('/:id',
  protect,
  authorize(['organizer', 'admin']),
  eventController.deleteEvent
);

module.exports = router;