const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { protect } = require('../middleware/authMiddleware');
const { authorize } = require('../middleware/roleMiddleware');

const eventValidation = [
  body('title').trim().notEmpty().withMessage('Event title is required'),
  body('description').trim().notEmpty().withMessage('Event description is required'),
  body('location').trim().notEmpty().withMessage('Event location is required'),
  body('date').isISO8601().toDate().withMessage('Valid event date is required'),
  body('maxParticipants').optional().isInt({ min: 1 }).withMessage('Max participants must be a positive number')
];

router.get('/', /* eventController.getAllEvents */);
router.get('/:id', /* eventController.getEventById */);

router.get('/my-registrations',
  protect,
);

router.post('/:id/register',
  protect,
);

router.post('/',
  protect,
  authorize(['organizer', 'admin']),
  eventValidation,
);

router.put('/:id',
  protect,
  authorize(['organizer', 'admin']),
  eventValidation,
);

router.delete('/:id',
  protect,
  authorize(['organizer', 'admin']),
);

router.get('/admin/all-events',
  protect,
  authorize('admin'),
);

module.exports = router;