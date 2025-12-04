from sqlalchemy.orm import Session
import models, schemas

def create_movie(db: Session, movie: schemas.MovieCreate):
    db_movie = models.Movie(title=movie.title, description=movie.description)
    db.add(db_movie)
    db.commit()
    db.refresh(db_movie)
    return db_movie

def get_movies(db: Session):
    return db.query(models.Movie).all()


def create_showtime(db: Session, showtime: schemas.ShowtimeCreate):
    db_show = models.Showtime(movie_id=showtime.movie_id, time=showtime.time)
    db.add(db_show)
    db.commit()
    db.refresh(db_show)
    return db_show

def get_showtimes(db: Session):
    return db.query(models.Showtime).all()


def book_ticket(db: Session, ticket: schemas.TicketCreate):
    db_ticket = models.Ticket(showtime_id=ticket.showtime_id, seat_number=ticket.seat_number)
    db.add(db_ticket)
    db.commit()
    db.refresh(db_ticket)
    return db_ticket

def get_tickets(db: Session):
    return db.query(models.Ticket).all()

def get_tickets_by_showtime(db: Session, showtime_id: int):
    return db.query(models.Ticket).filter(models.Ticket.showtime_id == showtime_id).all()
